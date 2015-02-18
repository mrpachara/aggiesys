<?php
	namespace app;

	class CarriageService extends \sys\DataService {
		protected static function getSearchableFields(){
			return array(
				  'code'
				, 'name'
				, 'registration'
				, 'etcitem.code'
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
					, "registration" => null
					, "code_typecarriage" => null
					, "name_typecarriage" => null
				);
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
						  "carriage"."id"
						, "carriage"."code"
						, "carriage"."name"
						, "carriage"."registration"
						, "carriage"."code_typecarriage"
						, "etcitem"."value" AS "name_typecarriage"
					FROM "carriage"
						LEFT JOIN (
							SELECT "etcitem"."code" AS "code", "etcitem"."value" AS "value"
							FROM "etcitem" JOIN "etc" ON("etcitem"."id_etc" = "etc"."id")
							WHERE "etc"."code" = \'TYPE_CARRIAGE\'
						) AS "etcitem" ON ("carriage"."code_typecarriage" = "etcitem"."code")
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);
			}

			return $data;
		}

		public function getAllEntity($where, $limit, &$pageData){
			$sqlPattern = '
				SELECT
					  "carriage"."id"
					, "carriage"."code"
					, "carriage"."name"
					, "carriage"."registration"
					, "carriage"."code_typecarriage"
					, "etcitem"."value" AS "name_typecarriage"
				FROM "carriage"
					LEFT JOIN (
						SELECT "etcitem".*
						FROM "etcitem" JOIN "etc" ON("etcitem"."id_etc" = "etc"."id")
						WHERE "etc"."code" = \'TYPE_CARRIAGE\'
					) AS "etcitem" ON ("carriage"."code_typecarriage" = "etcitem"."code")
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
					INSERT INTO "carriage" (
						  "code"
						, "name"
						, "registration"
						, "code_typecarriage"
					) VALUES (
						  :code
						, :name
						, :registration
						, :code_typecarriage
					)
				;');
				$stmt->execute(array(
					  ':code' => $data['code']
					, ':name' => $data['name']
					, ':registration' => $data['registration']
					, ':code_typecarriage' => $data['code_typecarriage']
				));

				$id = $data['id'] = $this->getPdo()->lastInsertId('carriage_id_seq');
			} else{
				$stmt = $this->getPdo()->prepare('
					UPDATE "carriage" SET
						  "code" = :code
						, "name" = :name
						, "registration" = :registration
						, "code_typecarriage" = :code_typecarriage
					WHERE
						"id" = :id
				;');
				$stmt->execute(array(
					  ':code' => $data['code']
					, ':name' => $data['name']
					, ':registration' => $data['registration']
					, ':code_typecarriage' => $data['code_typecarriage']
					, ':id' => $id
				));

				$data['id'] = $id;
			}

			return $id;
		}

		public function deleteEntity($id){
			$stmt = $this->getPdo()->prepare('
				DELETE FROM "carriage"
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $id
			));

			return $id;
		}
	}
?>
