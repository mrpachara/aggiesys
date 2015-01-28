<?php
	namespace app;

	class UserService {
		private $pdo;

		function __construct(){
			$this->pdo = new \sys\PDO();
		}

		private function getRoles($id_user){
			$stmt = $this->pdo->prepare('SELECT "role" FROM "userrole" WHERE "id_user" = :id_user;');
			$stmt->execute(array(
				 ':id_user' => $id_user
			));

			return $stmt->fetchAll(\PDO::FETCH_COLUMN);
		}

		function get($id = null){
			$user = null;
			if($id === null) {
				$user = array(
					 "username" => null
					,"fullname" => null
					,"roles" => array()
				);
			} else{
				$stmt = $this->pdo->prepare('SELECT "id", "username", "fullname" FROM "user" WHERE "id" = :id;');
				$stmt->execute(array(
					 ':id' => $id
				));

				$user = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($user['id'])){
					$user['roles'] = $this->getRoles($user['id']);
				}
			}

			return $user;
		}

		function getAll(){
			$stmt = $this->pdo->prepare('SELECT "id", "username", "fullname" FROM "user";');
			$stmt->execute();

			$users = $stmt->fetchAll(\PDO::FETCH_ASSOC);

			foreach($users as &$user){
				if(!empty($user['id'])){
					$user['roles'] = $this->getRoles($user['id']);
				}
			}

			return $users;
		}

		function save($id, $data){
			$this->pdo->beginTransaction();

			try{
				if($id === null){
					$stmt = $this->pdo->prepare('
						INSERT INTO "user" (
							  "username"
							, "fullname"
						) VALUES(
							  :username
							, :fullname
						)
					;');
					$stmt->execute(array(
						  ':username' => $data['username']
						, ':password' => $data['password']
					));

					$id = $this->pdo->lastInsertId();
				} else{
					$stmt = $this->pdo->prepare('
						UPDATE "user" SET
							  "username" = :username
							, "fullname" = :fullname
						WHERE
							"id" = :id
					;');
					$stmt->execute(array(
						  ':username' => $data['username']
						, ':password' => $data['password']
						, ':id' => $id
					));
				}

				
			} catch(\PDOException $excp){
			} finally{
				if(empty($excp)){
					return $this->pdo->commit();
				} else{
					$this->pdo->rollBack();
					throw $excp;
				}
			}

			return false;
		}
	}
?>
