<?php
	namespace app;

	class GeneratorService {
		private $pdo;
		private $rn;

		function __construct($code){
			$this->pdo = new \sys\PDO();
			$this->pdo->beginTransaction();

			$code_renew = "to_char(current_date, 'YYMMDD')";
			if($code > 80){
				$code_renew = "''";
			}

			$stmt = $this->pdo->prepare('
				SELECT
					  "id" AS "id"
					, (CASE WHEN "code_reuse" = '.$code_renew.'
						THEN concat("code", "code_reuse", lpad("num"::character, "length", \'0\'))
						ELSE concat("code", '.$code_renew.', lpad(\'1\', "length", \'0\'))
					END) AS "rn"
					, (CASE WHEN "code_reuse" = '.$code_renew.' THEN "code_reuse" ELSE '.$code_renew.' END) AS "code_reuse"
					, (CASE WHEN "code_reuse" = '.$code_renew.' THEN ("num" + 1) ELSE 2 END) AS "num"
				FROM "generator"
				WHERE "code" = :code
				FOR UPDATE
			;');
			$stmt->execute(array(
				  ':code' => $code
			));

			if(!($this->rn = $stmt->fetch(\PDO::FETCH_ASSOC))){
				throw new Exception("Unknown '{$code}' generator!!!", 500);
			}
		}

		public function getRn(){
			return $this->rn['rn'];
		}

		public function complete(){
			$stmt = $this->pdo->prepare('
				UPDATE "generator" SET
					  "code_reuse" = :code_reuse
					, "num" = :num
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':code_reuse' => $this->rn['code_reuse']
				, ':num' => $this->rn['num']
				, ':id' => $this->rn['id']
			));

			if($stmt->rowCount() == 1){
				$this->pdo->commit();
			} else{
				$this->pdo->rollBack();
			}
		}

		public function reject(){
			$this->pdo->rollBack();
		}
	}

?>
