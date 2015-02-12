<?php
	namespace app;

	class CustomerService extends \sys\DataService {
		protected static function getSearchableFields(){
			return array(
				  'code'
				, 'name'
				, 'address'
			);
		}

		function __construct(){
			parent::__construct();
		}

		protected function getEntity($id, $where){
			$data = false;
			if($id === null) {
				$data = array(
					  "id" => null
					, "code" => null
					, "name" => null
					, "address" => null
				);
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
						  "id"
						, "code"
						, "name"
						, "address"
					FROM "customer"
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);
			}

			return $data;
		}

		public function getAllEntity($where, $limit, &$pageData){
			$sqlPattern = '
				SELECT DISTINCT
					  "customer"."id" AS "id"
					, "customer"."code" AS "code"
					, "customer"."name" AS "name"
					, "customer"."address" AS "address"
				FROM "customer"
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
					INSERT INTO "customer" (
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

				$id = $data['id'] = $this->getPdo()->lastInsertId('customer_id_seq');
			} else{
				$stmt = $this->getPdo()->prepare('
					UPDATE "customer" SET
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
				DELETE FROM "customer"
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $id
			));

			return $id;
		}
	}
?>
