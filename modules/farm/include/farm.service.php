<?php
	namespace app;

	class FarmService extends \sys\DataService {
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
					FROM "farm"
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
					  "farm"."id" AS "id"
					, "farm"."code" AS "code"
					, "farm"."name" AS "name"
					, "farm"."address" AS "address"
				FROM "farm"
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
					INSERT INTO "farm" (
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

				$id = $data['id'] = $this->getPdo()->lastInsertId('farm_id_seq');
			} else{
				$stmt = $this->getPdo()->prepare('
					UPDATE "farm" SET
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
				DELETE FROM "farm"
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $id
			));

			return $id;
		}
	}
?>
