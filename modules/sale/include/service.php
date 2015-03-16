<?php
	namespace app;

	class SaleService extends \sys\DataService {
		protected static function getSearchableFields(){
			return array(
				  'doc.code'
				, 'doc.date'
				, 'customer.code'
				, 'salehead.fullname'
				, 'salehead.address'
				, 'carriage.code'
			);
		}

		protected static function extendAction(&$data){
			global $conf;

			if(empty($data)) return;

			$data['_updatable'] = $data['_deletable'] = (!$data['_isrefered'] && !$data['iscanceled']);
		}

		private $generatorClass;
		private $customerService;
		private $carriageService;
		private $vegetableService;

		function __construct($generatorClass, $customerService, $carriageService, $vegetableService){
			parent::__construct();

			$this->generatorClass = $generatorClass;
			$this->customerService = $customerService;
			$this->carriageService = $carriageService;
			$this->vegetableService = $vegetableService;
		}

		private function prepareRefEntity(&$data){
			/* customer */
			if($customer = $this->customerService->get($data['id_customer'])){
				if(!empty($data['fullname'])) $customer['name'] = $data['fullname'];
				if(!empty($data['address'])) $customer['address'] = $data['address'];

				$data['customer'] = $customer;
			}

			unset($data['id_customer']);

			/* carriage */
			if($customer = $this->carriageService->get($data['id_carriage'])){
				$data['carriage'] = $customer;
			}

			unset($data['id_carriage']);

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

		private function getDocrefs($id_head){
			$stmt = $this->getPdo()->prepare('
				SELECT
					  "deliveryhead"."id"
				FROM "docref"
					LEFT JOIN "doc" ON ("docref"."id_ref" = "doc"."id")
					INNER JOIN "deliveryhead" ON ("deliveryhead"."id_doc" = "doc"."id")
				WHERE "docref"."id_doc" = (SELECT "id_doc" FROM "salehead" WHERE "id" = :id_head) ORDER BY "doc"."tstmp" DESC
			;');
			$stmt->execute(array(
				  ':id_head' => $id_head
			));

			return $stmt->fetchAll(\PDO::FETCH_COLUMN);
		}

		private function getDetails($id_head){
			$stmt = $this->getPdo()->prepare('
				SELECT
					  "saledetail"."id" AS "id"
					, "saledetail"."id_vegetable" AS "id_vegetable"
					, "docdetail"."qty" AS "qty"
					, "docdetail"."price" AS "price"
				FROM "saledetail"
					LEFT JOIN "docdetail" ON("saledetail"."id_docdetail" = "docdetail"."id")
				WHERE "docdetail"."id_doc" = (SELECT "id_doc" FROM "salehead" WHERE "id" = :id_head) ORDER BY "id" ASC
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
					, "id_customer" => null
					, "fullname" => null
					, "address" => null
					, "iscanceled" => false
					, 'customer' => array(
						  'id' => null
						, 'code' => null
						, 'name' => null
						, 'address' => null
					)
					, 'carriage' => array(
						  'id' => null
						, 'code' => null
						, 'name' => null
						, 'registration' => null
					)
					, 'creator' => array(
						  'id' => null
						, 'username' => null
						, 'fullname' => null
					)
					, "deliveries" => array()
					, "details" => array()
				);

				$data['_isrefered'] = false;
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
					  "id"
					, (\''.call_user_func(array($this->generatorClass, 'getAutoText')).'\') AS "_code"
					, "id_customer"
					, "fullname"
					, "address"
					, "id_carriage"
					, "id_doc"
					FROM "salehead"
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

					$data['deliveries'] = $this->getDocrefs($data['id']);
					$data['details'] = $this->getDetails($data['id']);

					$stmt = $this->getPdo()->prepare('
						SELECT
							  COUNT("docref"."id_doc") AS "numref"
						FROM "docref"
							LEFT JOIN "doc" ON ("docref"."id_doc" = "doc"."id")
						WHERE
							    ("doc"."id_doc" IS NULL)
							AND ("id_ref" = (SELECT "id_doc" FROM "salehead" WHERE "id" = :id))
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
					  "salehead"."id" AS "id"
					, "doc"."code" AS "code"
					, '.\sys\PDO::getJsDate('"doc"."date"').' AS "date"
					, "salehead"."id_customer" AS "id_customer"
					, "salehead"."fullname" AS "fullname"
					, "salehead"."address" AS "address"
					, "salehead"."id_carriage" AS "id_carriage"
					, "doc"."id_creator" AS "id_creator"
					, ("doc"."id_doc" IS NOT NULL) AS "iscanceled"
				FROM "salehead"
					LEFT JOIN "doc" ON ("salehead"."id_doc" = "doc"."id")
					LEFT JOIN "customer" ON ("salehead"."id_customer" = "customer"."id")
					LEFT JOIN "carriage" ON ("salehead"."id_carriage" = "carriage"."id")
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
				  ':code' => $generator->getRn('13')
				, ':date' => $data['date']
				, ':type' => 'CREDIT'
				, ':id_creator' => $GLOBALS['_session']->getUser()['id']
			));
			$id_doc = $this->getPdo()->lastInsertId('doc_id_seq');

			if(!empty($data['deliveries'])){
				/*
					IMPORTANT:
						Don't use allow criteria in locking phrase, it alway meet criteria (alway allow).
						Because it use before locked value to meet criteria.
						So lock with record criteria first and then check allow criteria later.
				*/
				$paramIn = array();
				$stmtDeliveries = $this->getPdo()->prepare('
					SELECT
						  "deliveryhead"."id" AS "id"
					FROM "deliveryhead"
					WHERE
						"deliveryhead"."id" IN ('.\sys\PDO::prepareIn(':id_deliveryhead', $data['deliveries'], $paramIn).')
					FOR UPDATE
				;');
				$stmtDeliveries->execute($paramIn);

				$locked_ids = $stmtDeliveries->fetchAll(\PDO::FETCH_COLUMN);

				$paramIn = array();
				$stmtDeliveries = $this->getPdo()->prepare('
					SELECT
						  "deliveryhead"."id" AS "id"
					FROM "deliveryhead"
					WHERE
						    ("deliveryhead"."id" IN ('.\sys\PDO::prepareIn(':id_deliveryhead', $locked_ids, $paramIn).'))
						AND ((
							SELECT
								  COUNT("docref"."id_ref")
							FROM "docref"
								LEFT JOIN "doc" AS "_unsold_doc" ON ("docref"."id_doc" = "_unsold_doc"."id")
								INNER JOIN "salehead" ON ("salehead"."id_doc" = "_unsold_doc"."id")
							WHERE
								    ("docref"."id_ref" = "deliveryhead"."id_doc")
								AND ("_unsold_doc"."id_doc" IS NULL)
								AND ("salehead"."id" <> :_unsold_id)
						) = 0)
					FOR UPDATE
				;');
				$stmtDeliveries->execute(array_merge(
					  $paramIn
					, array(
						  ':_unsold_id' => ($id !== null)? $id : 0
					)
				));

				if($data['deliveries'] != $stmtDeliveries->fetchAll(\PDO::FETCH_COLUMN)){
					throw new \sys\DataServiceException("update %s{$id} not allow deliveries", 500);
				}

				$stmt = $this->getPdo()->prepare('
					INSERT INTO "docref" (
					  "id_doc"
					, "id_ref"
					) VALUES (
						  :id_doc
						, (SELECT id_doc FROM "deliveryhead" WHERE "id" = :id_ref)
					)
				;');

				foreach($data['deliveries'] as $delivery){
					$stmt->execute(array(
						  ':id_doc' => $id_doc
						, ':id_ref' => $delivery
					));
				}
			}

			$stmt = $this->getPdo()->prepare('
				INSERT INTO "salehead" (
				  "id_doc"
				, "id_customer"
				, "fullname"
				, "address"
				, "id_carriage"
				) VALUES (
					  :id_doc
					, :id_customer
					, :fullname
					, :address
					, :id_carriage
				)
			;');
			$stmt->execute(array(
				  ':id_doc' => $id_doc
				, ':id_customer' => $data['customer']['id']
				, ':fullname' => $data['customer']['name']
				, ':address' => $data['customer']['address']
				, ':id_carriage' => (!empty($data['carriage']['id']))? $data['carriage']['id'] : null
			));

			$new_id = $data['id'] = $this->getPdo()->lastInsertId('salehead_id_seq');

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
				INSERT INTO "saledetail" (
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
				WHERE "id" = (SELECT "id_doc" FROM "salehead" WHERE "id" = :id)
			;');
			$stmt->execute(array(
				  ':id' => $id
				, ':id_doc' => $id_doc
			));
		}
	}
?>
