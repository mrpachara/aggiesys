<?php
	namespace app;

	class GeneratorService {
		private $pdo;

		public static function getAutoText(){
			return '<AUTO>';
		}

		function __construct(){
			$this->pdo = new \sys\PDOConfigurated();
		}

		public function getRn($code){
			$this->pdo->beginTransaction();

			$code_renew = "to_char(current_date, 'YYMMDD')";
			if($code > 80){
				$code_renew = "''";
			}

			$stmt = $this->pdo->prepare('
				SELECT
					  "id" AS "id"
					, (CASE WHEN "code_reuse" = '.$code_renew.'
						THEN concat("code", "code_reuse", lpad("num"::character varying, "length", \'0\'))
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

			if(!($rn = $stmt->fetch(\PDO::FETCH_ASSOC))){
				throw new \Exception("Unknown '{$code}' generator!!!", 500);
			}

			$stmt = $this->pdo->prepare('
				UPDATE "generator" SET
					  "code_reuse" = :code_reuse
					, "num" = :num
				WHERE "id" = :id
			;');
			$stmt->execute(array(
				  ':code_reuse' => $rn['code_reuse']
				, ':num' => $rn['num']
				, ':id' => $rn['id']
			));

			if($stmt->rowCount() == 1){
				$this->pdo->commit();
			} else{
				$this->pdo->rollBack();
				throw new Exception("Cannot update '{$code}' generator!!!", 500);
			}

			return $rn['rn'];
		}
	}
?>
