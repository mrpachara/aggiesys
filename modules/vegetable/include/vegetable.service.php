<?php
	namespace app;

	class VegetableService extends \sys\DataService {
		protected static function getSearchableFields(){
			return array(
				  'code'
				, 'name'
			);
		}

		private $generatorClass;

		function __construct($generatorClass){
			parent::__construct();

			$this->generatorClass = $generatorClass;
		}

		protected function getEntity($id, $where){
			$data = false;
			if($id === null) {
				$data = array(
					  "id" => null
					, "code" => "<AUTO>"
					, "name" => null
				);
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
						  "id"
						, "code"
						, "name"
					FROM "vegetable"
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
					  "vegetable"."id" AS "id"
					, "vegetable"."code" AS "code"
					, "vegetable"."name" AS "name"
				FROM "vegetable"
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
				$generator = new $this->generatorClass();
				$stmt = $this->getPdo()->prepare('
					INSERT INTO "vegetable" (
						  "code"
						, "name"
					) VALUES (
						  :code
						, :name
					)
				;');
				$stmt->execute(array(
					  ':code' => $generator->getRn('81')
					, ':name' => $data['name']
				));

				$id = $data['id'] = $this->getPdo()->lastInsertId('vegetable_id_seq');
			} else{
				$stmt = $this->getPdo()->prepare('
					UPDATE "vegetable" SET
						  "name" = :name
					WHERE
						"id" = :id
				;');
				$stmt->execute(array(
					  ':name' => $data['name']
					, ':id' => $id
				));

				$data['id'] = $id;
			}

			return $id;
		}

		public function deleteEntity($id){
			$stmt = $this->getPdo()->prepare('
				DELETE FROM "vegetable"
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $id
			));

			return $id;
		}
	}
?>
