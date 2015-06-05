<?php
	namespace app;

	class EmployeeService extends \sys\DataService {
		protected static function getSearchableFields(){
			return array(
				  'code'
				, 'fname'
				, 'lname'
			);
		}

		private $generatorClass;

		function __construct(/*$generatorClass*/){
			parent::__construct();

			//$this->generatorClass = $generatorClass;
		}

		protected function getEntity($id, $where, $forupdate){
			$data = false;
			if($id === null) {
				$data = array(
					  "id" => null
					, "code" => null
					, "fname" => null
					, "lname" => null
					, "address_line" => null
					, "address_rd" => null
					, "address_t" => null
					, "address_a" => null
					, "address_j" => null
					, "address_zipcode" => null
				);
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
						  "id"
						, "code"
						, "fname"
						, "lname"
						, "address_line"
						, "address_rd"
						, "address_t"
						, "address_a"
						, "address_j"
						, "address_zipcode"
					FROM "emplyee"
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
					'.(($forupdate)? 'FOR UPDATE' : '').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);
			}

			return $data;
		}

		public function getAllEntity($where, $limit, &$pageData){
			$sqlPattern = '
				SELECT DISTINCT
					  "employee"."id" AS "id"
					, "employee"."code" AS "code"
					, "employee"."fname" AS "fname"
					, "employee"."lname" AS "lname"
					, "employee"."address_line" AS "address_line"
					, "employee"."address_rd" AS "address_rd"
					, "employee"."address_t" AS "address_t"
					, "employee"."address_a" AS "address_a"
					, "employee"."address_j" AS "address_j"
					, "employee"."address_zipcode" AS "address_zipcode"
				FROM "employee"
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
					INSERT INTO "employee" (
						  "code"
						, "fname"
						, "lname"
						, "address_line"
						, "address_rd"
						, "address_t"
						, "address_a"
						, "address_j"
						, "address_zipcode"
					) VALUES (
						  :code
						, :fname
						, :lname
						, :address_line
						, :address_rd
						, :address_t
						, :address_a
						, :address_j
						, :address_zipcode
					)
				;');
				$stmt->execute(array(
					  ':code' => $data['code']
					, ':fname' => $data['fname']
					, ':lname' => $data['lname']
					, ':address_line' => $data['address_line']
					, ':address_rd' => $data['address_rd']
					, ':address_t' => $data['address_t']
					, ':address_a' => $data['address_a']
					, ':address_j' => $data['address_j']
					, ':address_zipcode' => $data['address_zipcode']
				));

				$id = $data['id'] = $this->getPdo()->lastInsertId('employee_id_seq');
			} else{
				$stmt = $this->getPdo()->prepare('
					UPDATE "employee" SET
						  "fname" = :fname
						, "lname" = :lname
						, "address_line" = :address_line
						, "address_rd" = :address_rd
						, "address_t" = :address_t
						, "address_a" = :address_a
						, "address_j" = :address_j
						, "address_zipcode" = :address_zipcode
					WHERE
						"id" = :id
				;');
				$stmt->execute(array(
					  ':code' => $data['code']
					, ':fname' => $data['fname']
					, ':lname' => $data['lname']
					, ':address_line' => $data['address_line']
					, ':address_rd' => $data['address_rd']
					, ':address_t' => $data['address_t']
					, ':address_a' => $data['address_a']
					, ':address_j' => $data['address_j']
					, ':address_zipcode' => $data['address_zipcode']
					, ':id' => $id
				));

				$data['id'] = $id;
			}

			return $id;
		}

		public function deleteEntity($id){
			$stmt = $this->getPdo()->prepare('
				DELETE FROM "employee"
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':id' => $id
			));

			return $id;
		}
	}
?>
