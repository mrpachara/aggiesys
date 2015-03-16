<?php
	namespace app;

	class EtcService extends \sys\DataService {
		protected static function getSearchableFields(){
			return array();
		}

		function __construct(){
			parent::__construct();
		}

		private function getItems($id_etc){
			$stmt = $this->getPdo()->prepare('SELECT * FROM "etcitem" WHERE "id_etc" = :id_etc ORDER BY "code" ASC;');
			$stmt->execute(array(
				  ':id_etc' => $id_etc
			));

			return $stmt->fetchAll(\PDO::FETCH_ASSOC);
		}

		protected function getEntity($id, $where, $forupdate){
			$data = false;
			if($id === null) {
				$data = array(
					  "id" => null
					, "code" => null
					, "name" => null
					, "items" => array()
				);
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
						  "id"
						, "code"
						, "name"
					FROM "etc"
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
					'.(($forupdate)? 'FOR UPDATE' : '').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($data['id'])){
					$data['items'] = $this->getItems($data['id']);
				}
			}

			return $data;
		}

		protected function getAllEntity($where, $limit, &$pageData){
			$sqlPattern = '
				SELECT
					  "etc"."id" AS "id"
					, "etc"."code" AS "code"
					, "etc"."name" AS "name"
				FROM "etc"
				'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
				%s
			';

			$stmt = $this->getPdo()->prepare(sprintf($sqlPattern.';', 'ORDER BY "code" ASC'));
			$stmt->execute($where['params']);

			$datas = $stmt->fetchAll(\PDO::FETCH_ASSOC);

			$pageData['page_current'] = null;

			return $datas;
		}

		protected function saveEntity($id, &$data){
			if(empty($data['items'])){
				throw new \sys\DataServiceException("update %s{$id} without items", 500);
			}

			if($id === null){
				$stmt = $this->getPdo()->prepare('
					INSERT INTO "etc" (
						  "code"
						, "name"
					) VALUES (
						  :code
						, :name
					)
				;');
				$stmt->execute(array(
					  ':code' => $data['code']
					, ':name' => $data['name']
				));

				$id = $data['id'] = $this->getPdo()->lastInsertId('etc_id_seq');
			} else{
				$stmt = $this->getPdo()->prepare('
					UPDATE "etc" SET
						  "code" = :code
						, "name" = :name
					WHERE
						"id" = :id
				;');
				$stmt->execute(array(
					  ':code' => $data['code']
					, ':name' => $data['name']
					, ':id' => $id
				));

				$data['id'] = $id;
			}

			if(!empty($id)){
				$stmt = $this->getPdo()->prepare('
					DELETE FROM "etcitem"
					WHERE "id_etc" = :id_etc
				;');
				$stmt->execute(array(
					  ':id_etc' => $id
				));
			}

			if(!empty($data['items'])){
				$stmt = $this->getPdo()->prepare('
					INSERT INTO "etcitem" (
						  "id_etc"
						, "code"
						, "value"
					) VALUES (
						  :id_etc
						, :code
						, :value
					)
				;');

				foreach($data['items'] as $item){
					$stmt->execute(array(
						  ':id_etc' => $data['id']
						, ':code' => $item['code']
						, ':value' => $item['value']
					));
				}
			}

			return $id;
		}

		protected function deleteEntity($id){
			$stmt = $this->getPdo()->prepare('
				DELETE FROM "etc"
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $id
			));

			return $id;
		}
	}
?>
