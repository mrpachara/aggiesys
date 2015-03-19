<?php
	namespace app;

	class DeliveryService extends \sys\DataService {
		protected static function getSearchableFields(){
			return array(
				  'doc.code'
				, 'doc.date'
				, 'farm.code'
				, 'deliveryhead.fullname'
				, 'deliveryhead.address'
			);
		}

		protected static function getWhereSearchSpecial(&$searchTerm){
			$where = array(
				  'sqls' => array()
				, 'params' => array()
			);

			if(!empty($searchTerm['specials']['isrefered'])){
				$checkText = '> 0';
				if($searchTerm['specials']['isrefered'][0] == 'false') $checkText = '= 0';

				$where['sqls'][] = sprintf('(
					(
						SELECT
							  COUNT("docref"."id_ref")
						FROM "docref"
							LEFT JOIN "doc" AS "isrefered_doc" ON ("docref"."id_doc" = "isrefered_doc"."id")
						WHERE
							("docref"."id_ref" = "doc"."id") AND ("isrefered_doc"."id_doc" IS NULL)
					) %s
				)', $checkText);
				$where['sqls'][] = '("doc"."id_doc" IS NULL)';
			}

			if(!empty($searchTerm['specials']['unsold'])){
				$except = explode(',', implode(',', $searchTerm['specials']['unsold']));

				$paramIn = array();
				$where['sqls'][] = '(
					(
						(
							SELECT
								  COUNT("docref"."id_ref")
							FROM "docref"
								LEFT JOIN "doc" AS "_unsold_doc" ON ("docref"."id_doc" = "_unsold_doc"."id")
								INNER JOIN "salehead" ON ("salehead"."id_doc" = "_unsold_doc"."id")
							WHERE
								    ("docref"."id_ref" = "doc"."id")
								AND ("_unsold_doc"."id_doc" IS NULL)
						) = 0
					)
					OR ("deliveryhead"."id" IN ('.\sys\PDO::prepareIn(':_unsold_id', $except, $paramIn).'))
				)';

				$where['params'] = array_merge($where['params'], $paramIn);

				$where['sqls'][] = '("doc"."id_doc" IS NULL)';
			}

			if(!empty($searchTerm['specials']['id'])){
				$ids = explode(',', implode(',', $searchTerm['specials']['id']));

				$paramIn = array();
				$where['sqls'][] = '("deliveryhead"."id" IN ('.\sys\PDO::prepareIn(':_ids_id', $ids, $paramIn).'))';

				$where['params'] = array_merge($where['params'], $paramIn);
			}

			return $where;
		}

		protected static function extendAction(&$data){
			global $conf;

			if(empty($data)) return;

			$data['_updatable'] = $data['_deletable'] = (!$data['_isrefered'] && !$data['iscanceled']);
		}

		private $generatorClass;
		private $farmService;
		private $vegetableService;

		function __construct($generatorClass, $farmService, $vegetableService){
			parent::__construct();

			$this->generatorClass = $generatorClass;
			$this->farmService = $farmService;
			$this->vegetableService = $vegetableService;
		}

		private function prepareRefEntity(&$data){
			if($farm = $this->farmService->get($data['id_farm'])){
				if(!empty($data['fullname'])) $farm['name'] = $data['fullname'];
				if(!empty($data['address'])) $farm['address'] = $data['address'];

				$data['farm'] = $farm;
			}

			unset($data['id_farm']);

			/* creator */
			$stmt = $this->getPdo()->prepare('
				SELECT
					  "id"
					, "username"
					, "fullname"
				FROM "user" WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $data['id_creator']
			));

			if($creator = $stmt->fetch(\PDO::FETCH_ASSOC)){
				$data['creator'] = $creator;
			}

			unset($data['id_creator']);

			return $data;
		}

		private function getDetails($id_head){
			$stmt = $this->getPdo()->prepare('
				SELECT
					  "deliverydetail"."id" AS "id"
					, "deliverydetail"."id_vegetable" AS "id_vegetable"
					, "docdetail"."qty" AS "qty"
					, "docdetail"."price" AS "price"
				FROM "deliverydetail"
					LEFT JOIN "docdetail" ON("deliverydetail"."id_docdetail" = "docdetail"."id")
				WHERE "docdetail"."id_doc" = (SELECT "id_doc" FROM "deliveryhead" WHERE "id" = :id_head) ORDER BY "id" ASC
			;');
			$stmt->execute(array(
				  ':id_head' => $id_head
			));

			$details = $stmt->fetchAll(\PDO::FETCH_ASSOC);

			foreach($details as &$detail){
				$detail['vegetable'] = $this->vegetableService->get($detail['id_vegetable']);
			}

			return $details;
		}

		protected function getEntity($id, $where, $forupdate){
			$data = false;
			if($id === null) {
				$stmt = $this->getPdo()->prepare('SELECT '.\sys\PDO::getJsDate('CURRENT_TIMESTAMP').';');
				$stmt->execute();
				$currentstmt = $stmt->fetchColumn();
				$data = array(
					  "id" => null
					, "code" => call_user_func(array($this->generatorClass, 'getAutoText'))
					, "date" => $currentstmt
					, "id_farm" => null
					, "fullname" => null
					, "address" => null
					, "iscanceled" => false
					, 'farm' => array(
						  'id' => null
						, 'code' => null
						, 'name' => null
						, 'address' => null
					)
					, 'creator' => array(
						  'id' => null
						, 'username' => null
						, 'fullname' => null
					)
					, "details" => array()
				);

				$data['_isrefered'] = false;
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
					  "id"
					, (\''.call_user_func(array($this->generatorClass, 'getAutoText')).'\') AS "_code"
					, "id_farm"
					, "fullname"
					, "address"
					, "id_doc"
					FROM "deliveryhead"
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
					'.(($forupdate)? 'FOR UPDATE' : '').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($data['id'])){
					$stmt = $this->getPdo()->prepare('
						SELECT
						  "code"
						, '.\sys\PDO::getJsDate('"date"').' AS "date"
						, "id_creator"
						, ("id_doc" IS NOT NULL) AS "iscanceled"
						FROM "doc"
						WHERE "id" = :id
					;');
					$stmt->execute(array(
						  ':id' => $data['id_doc']
					));

					$data = array_merge($data,$stmt->fetch(\PDO::FETCH_ASSOC));

					$this->prepareRefEntity($data);

					$data['details'] = $this->getDetails($data['id']);

					$stmt = $this->getPdo()->prepare('
						SELECT
							  COUNT("docref"."id_doc") AS "numref"
						FROM "docref"
							LEFT JOIN "doc" ON ("docref"."id_doc" = "doc"."id")
						WHERE
							    ("doc"."id_doc" IS NULL)
							AND ("id_ref" = (SELECT "id_doc" FROM "deliveryhead" WHERE "id" = :id))
					;');
					$stmt->execute(array(
						  ':id' => $data['id']
					));

					$data['_isrefered'] = ($stmt->fetchColumn() > 0);
				}
			}

			return $data;
		}

		protected function getAllEntity($where, $limit, &$pageData){
			$sqlPattern = '
				SELECT
					  "deliveryhead"."id" AS "id"
					, "doc"."code" AS "code"
					, '.\sys\PDO::getJsDate('"doc"."date"').' AS "date"
					, "deliveryhead"."id_farm" AS "id_farm"
					, "deliveryhead"."fullname" AS "fullname"
					, "deliveryhead"."address" AS "address"
					, "doc"."id_creator" AS "id_creator"
					, ("doc"."id_doc" IS NOT NULL) AS "iscanceled"
				FROM "deliveryhead"
					LEFT JOIN "doc" ON ("deliveryhead"."id_doc" = "doc"."id")
					LEFT JOIN "farm" ON ("deliveryhead"."id_farm" = "farm"."id")
				'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
				%s
			';

			if(!empty($pageData['current'])){
				$stmt = $this->getPdo()->prepare(sprintf('
					SELECT count("_realdata".*) AS "numrows" FROM (%s) AS "_realdata";
				', sprintf($sqlPattern, '')));
				$stmt->execute($where['params']);
				$pageData['total'] = ceil($stmt->fetchColumn() / $pageData['limit']);
			}

			$stmt = $this->getPdo()->prepare(sprintf($sqlPattern.';', 'ORDER BY "doc"."tstmp" DESC '.$limit));
			$stmt->execute($where['params']);

			$datas = $stmt->fetchAll(\PDO::FETCH_ASSOC);
			foreach($datas as &$data){
				$this->prepareRefEntity($data);
			}

			if(!empty($pageData['current'])){
				if($pageData['current'] > 1){
					$pageData['previous'] = $pageData['current'] - 1;
				}

				if($pageData['current'] < $pageData['total']){
					$pageData['next'] = $pageData['current'] + 1;
				}
			}

			return $datas;
		}

		protected function saveEntity($id, &$data){
			if(empty($data['details'])){
				throw new \sys\DataServiceException("update %s{$id} without details", 500);
			}

			$generator = new $this->generatorClass();
			$stmt = $this->getPdo()->prepare('
				INSERT INTO "doc" (
				  "code"
				, "date"
				, "type"
				, "id_creator"
				) VALUES (
					  :code
					, :date
					, :type
					, :id_creator
				)
			;');
			$stmt->execute(array(
				  ':code' => $generator->getRn('11')
				, ':date' => $data['date']
				, ':type' => 'DEBIT'
				, ':id_creator' => $GLOBALS['_session']->getUser()['id']
			));
			$id_doc = $this->getPdo()->lastInsertId('doc_id_seq');

			$stmt = $this->getPdo()->prepare('
				INSERT INTO "deliveryhead" (
				  "id_doc"
				, "id_farm"
				, "fullname"
				, "address"
				) VALUES (
					  :id_doc
					, :id_farm
					, :fullname
					, :address
				)
			;');
			$stmt->execute(array(
				  ':id_doc' => $id_doc
				, ':id_farm' => $data['farm']['id']
				, ':fullname' => $data['farm']['name']
				, ':address' => $data['farm']['address']
			));

			$new_id = $data['id'] = $this->getPdo()->lastInsertId('deliveryhead_id_seq');

			$stmtDocdetail = $this->getPdo()->prepare('
				INSERT INTO "docdetail" (
					  "id_doc"
					, "item"
					, "qty"
					, "price"
				) VALUES (
					  :id_doc
					, :item
					, :qty
					, :price
				)
			;');

			$stmtDetail = $this->getPdo()->prepare('
				INSERT INTO "deliverydetail" (
					  "id_docdetail"
					, "id_vegetable"
				) VALUES (
					  :id_docdetail
					, :id_vegetable
				)
			;');

			foreach($data['details'] as $detail){
				$stmtDocdetail->execute(array(
					  ':id_doc' => $id_doc
					, ':item' => $detail['vegetable']['name']
					, ':qty' => $detail['qty']
					, ':price' => $detail['price']
				));
				$id_docdetail = $this->getPdo()->lastInsertId('docdetail_id_seq');

				$stmtDetail->execute(array(
					  ':id_docdetail' => $id_docdetail
					, ':id_vegetable' => $detail['vegetable']['id']
				));
			}

			if($id !== null) $this->replaceEntity($id, $id_doc);

			return $new_id;
		}

		protected function deleteEntity($id){
			$generator = new $this->generatorClass();
			$stmt = $this->getPdo()->prepare('
				INSERT INTO "doc" (
				  "code"
				, "date"
				, "type"
				, "id_creator"
				) VALUES (
					  :code
					, CURRENT_TIMESTAMP
					, :type
					, :id_creator
				)
			;');
			$stmt->execute(array(
				  ':code' => $generator->getRn('00')
				, ':type' => 'CANCEL'
				, ':id_creator' => $GLOBALS['_session']->getUser()['id']
			));
			$id_doc = $this->getPdo()->lastInsertId('doc_id_seq');

			$this->replaceEntity($id, $id_doc);

			return $id;
		}

		protected function replaceEntity($id, $id_doc){
			$stmt = $this->getPdo()->prepare('
				UPDATE "doc" SET
					  "id_doc" = :id_doc
				WHERE "id" = (SELECT "id_doc" FROM "deliveryhead" WHERE "id" = :id)
			;');
			$stmt->execute(array(
				  ':id' => $id
				, ':id_doc' => $id_doc
			));
		}
	}
?>
