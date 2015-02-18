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

		function __construct(){
			parent::__construct();
		}

		private function putFarm(&$data){
			$stmt = $this->getPdo()->prepare('SELECT * FROM "farm" WHERE "id" = :id;');
			$stmt->execute(array(
				  ':id' => $data['id_farm']
			));

			if($farm = $stmt->fetch(\PDO::FETCH_ASSOC)){
				if(!empty($data['fullname'])) $farm['name'] = $data['fullname'];
				if(!empty($data['address'])) $farm['address'] = $data['address'];
			}

			return $data['farm'] = $farm;
		}

		private function getDetails($id_head){
			$stmt = $this->getPdo()->prepare('SELECT * FROM "deliverydetail" WHERE "id_deliveryhead" = :id_head ORDER BY "id" ASC;');
			$stmt->execute(array(
				  ':id_head' => $id_head
			));

			return $stmt->fetchAll(\PDO::FETCH_ASSOC);
		}

		protected function getEntity($id, $where){
			$data = false;
			if($id === null) {
				$data = array(
					  "id" => null
					, "code" => '<Auto>'
					, "date" => date("Y-m-d H:i:s".".123")
					, "id_farm" => null
					, "fullname" => null
					, "address" => null
					, 'farm' => array(
						  'id' => null
						, 'code' => null
						, 'name' => null
						, 'address' => null
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
					FROM "deliveryhead"
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($data['id'])){
					$this->putFarm($data);

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
				$this->putFarm($data);
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
				$stmt = $this->getPdo()->prepare('
					INSERT INTO "deliveryhead" (
						  "code"
						, "name"
						, "address"
					) VALUES (
						  :code
						, :name
						, :address
					)
				;');
				$stmt->execute(array(
					  ':code' => $data['code']
					, ':name' => $data['name']
					, ':address' => $data['address']
				));

				$id = $data['id'] = $this->getPdo()->lastInsertId('deliveryhead_id_seq');
			} else{
				$stmt = $this->getPdo()->prepare('
					UPDATE "deliveryhead" SET
						  "code" = :code
						, "name" = :name
						, "address" = :address
					WHERE
						"id" = :id
				;');
				$stmt->execute(array(
					  ':code' => $data['code']
					, ':name' => $data['name']
					, ':address' => $data['address']
					, ':id' => $id
				));

				$data['id'] = $id;
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
