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
				$stmt = $this->getPdo()->prepare('SELECT LOCALTIMESTAMP(0);');
				$stmt->execute();
				$localtstmt = $stmt->fetchColumn();
				$data = array(
					  "id" => null
					, "code" => call_user_func(array($this->generatorClass, 'getAutoText'))
					, "date" => $localtstmt
					, "id_farm" => null
					, "fullname" => null
					, "address" => null
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
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
					  "id"
					, "code"
					, "date"
					, "id_farm"
					, "fullname"
					, "address"
					, "id_creator"
					FROM "deliveryhead"
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($data['id'])){
					$this->prepareRefEntity($data);

					$data['details'] = $this->getDetails($data['id']);
				}
			}

			return $data;
		}

		public function getAllEntity($where, $limit, &$pageData){
			$sqlPattern = '
				SELECT
					  "deliveryhead"."id" AS "id"
					, "deliveryhead"."code" AS "code"
					, "deliveryhead"."date" AS "date"
					, "deliveryhead"."id_farm" AS "id_farm"
					, "deliveryhead"."fullname" AS "fullname"
					, "deliveryhead"."address" AS "address"
					, "deliveryhead"."id_creator" AS "id_creator"
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

			$stmt = $this->getPdo()->prepare(sprintf($sqlPattern.';', 'ORDER BY "code" ASC '.$limit));
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

		public function saveEntity($id, &$data){
			if($id === null){
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
			} else{
				$stmt = $this->getPdo()->prepare('
					UPDATE "deliveryhead" SET
						  "date" = :date
						, "id_farm" = :id_fard
						, "fullname" = :fullname
						, "address" = :address
					WHERE
						"id" = :id
				;');
				$stmt->execute(array(
					  ':date' => $data['date']
					, ':id_fram' => $data['farm']['id']
					, ':fullname' => $data['farm']['name']
					, ':address' => $data['farm']['address']
					, ':id' => $id
				));

				$data['id'] = $id;
			}

			if(!empty($id)){
				$stmt = $this->getPdo()->prepare('
					DELETE FROM "deliverydetail"
					WHERE "id_deliveryhead" = :id_head
				;');
				$stmt->execute(array(
					  ':id_head' => $id
				));
			}

			if(!empty($data['details'])){
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
			}

			return $id;
		}

		public function deleteEntity($id){
			$stmt = $this->getPdo()->prepare('
				DELETE FROM "deliveryhead"
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $id
			));

			return $id;
		}
	}
?>
