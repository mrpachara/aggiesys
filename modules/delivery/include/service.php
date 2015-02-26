<?php
	namespace app;

	class DeliveryService extends \sys\DataService {
		protected static function getSearchableFields(){
			return array(
				  'deliveryhead.code'
				, 'deliveryhead.date'
				, 'farm.code'
				, 'farm.name'
				, 'farm.address'
			);
		}

		protected static function extendAction(&$data){
			global $conf;

			if(empty($data)) return;

			$data['_updatable'] = $data['_deletable'] = (!$data['_isrefered'] && !$data['iscanceled']);
		}

		private $generatorClass;

		function __construct($generatorClass){
			parent::__construct();

			$this->generatorClass = $generatorClass;
		}

		private function prepareRefEntity(&$data){
			/* farm */
			$stmt = $this->getPdo()->prepare('SELECT * FROM "farm" WHERE "id" = :id;');
			$stmt->execute(array(
				  ':id' => $data['id_farm']
			));

			if($farm = $stmt->fetch(\PDO::FETCH_ASSOC)){
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
			$stmt = $this->getPdo()->prepare('SELECT * FROM "deliverydetail" WHERE "id_deliveryhead" = :id_head ORDER BY "id" ASC;');
			$stmt->execute(array(
				  ':id_head' => $id_head
			));

			$details = $stmt->fetchAll(\PDO::FETCH_ASSOC);

			foreach($details as &$detail){
				$stmt = $this->getPdo()->prepare('
					SELECT
						  "id"
						, "code"
						, "name"
					FROM "vegetable"
					WHERE "id" = :id
				;');

				$stmt->execute(array(
					  ':id' => $detail['id_vegetable']
				));

				$detail['vegetable'] = $stmt->fetch(\PDO::FETCH_ASSOC);
			}

			return $details;
		}

		protected function getEntity($id, $where){
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
					, "tstmp_canceled" => null
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
					, "code"
					, (\''.call_user_func(array($this->generatorClass, 'getAutoText')).'\') AS "_code"
					, '.\sys\PDO::getJsDate('"date"').' AS "date"
					, "id_farm"
					, "fullname"
					, "address"
					, "id_creator"
					, "tstmp_canceled"
					, ("tstmp_canceled" IS NOT NULL) AS "iscanceled"
					FROM "deliveryhead"
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($data['id'])){
					$this->prepareRefEntity($data);

					$data['details'] = $this->getDetails($data['id']);

					$data['_isrefered'] = false;

					$this->getPdo()->beginTransaction();

					try{
						$stmt = $this->getPdo()->prepare('
							DELETE FROM "deliveryhead"
							WHERE "id" = :id
						;');
						$stmt->execute(array(
							  ':id' => $data['id']
						));
					} catch(\PDOException $excp){
						echo $excp->getMessage();
						$data['_isrefered'] = true;
					}

					$this->getPdo()->rollBack();
				}
			}

			return $data;
		}

		protected function getAllEntity($where, $limit, &$pageData){
			$sqlPattern = '
				SELECT
					  "deliveryhead"."id" AS "id"
					, "deliveryhead"."code" AS "code"
					, '.\sys\PDO::getJsDate('"deliveryhead"."date"').' AS "date"
					, "deliveryhead"."id_farm" AS "id_farm"
					, "deliveryhead"."fullname" AS "fullname"
					, "deliveryhead"."address" AS "address"
					, "deliveryhead"."id_creator" AS "id_creator"
					, ("deliveryhead"."tstmp_canceled" IS NOT NULL) AS "iscanceled"
				FROM "deliveryhead" LEFT JOIN "farm" ON ("deliveryhead"."id_farm" = "farm"."id")
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

			$stmt = $this->getPdo()->prepare(sprintf($sqlPattern.';', 'ORDER BY "deliveryhead"."tstmp" DESC '.$limit));
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

			if($id !== null) $this->deleteEntity($id);

			$generator = new $this->generatorClass();
			$stmt = $this->getPdo()->prepare('
				INSERT INTO "deliveryhead" (
				  "code"
				, "date"
				, "id_farm"
				, "fullname"
				, "address"
				, "id_creator"
				) VALUES (
					  :code
					, :date
					, :id_farm
					, :fullname
					, :address
					, :id_creator
				)
			;');
			$stmt->execute(array(
				  ':code' => $generator->getRn('11')
				, ':date' => $data['date']
				, ':id_farm' => $data['farm']['id']
				, ':fullname' => $data['farm']['name']
				, ':address' => $data['farm']['address']
				, ':id_creator' => $GLOBALS['_session']->getUser()['id']
			));

			$id = $data['id'] = $this->getPdo()->lastInsertId('deliveryhead_id_seq');

			$stmt = $this->getPdo()->prepare('
				INSERT INTO "deliverydetail" (
					  "id_deliveryhead"
					, "id_vegetable"
					, "qty"
					, "price"
				) VALUES (
					  :id_head
					, :id_vegetable
					, :qty
					, :price
				)
			;');

			foreach($data['details'] as $detail){
				$stmt->execute(array(
					  ':id_head' => $data['id']
					, ':id_vegetable' => $detail['vegetable']['id']
					, ':qty' => $detail['qty']
					, ':price' => $detail['price']
				));
			}

			return $id;
		}

		protected function deleteEntity($id){
			$stmt = $this->getPdo()->prepare('
				UPDATE "deliveryhead" SET
					  "tstmp_canceled" = CURRENT_TIMESTAMP
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $id
			));

			return $id;
		}
	}
?>
