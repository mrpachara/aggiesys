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
			//return $stmt->fetchAll(\PDO::FETCH_ASSOC);
		}

		function get($id){
			$stmt = $this->pdo->prepare('SELECT "username", "fullname" FROM "user" WHERE "id" = :id;');
			$stmt->execute(array(
				 ':id' => $id
			));

			$user = $stmt->fetchAll(\PDO::FETCH_ASSOC);

			if(!empty($user['id'])){
				$user['roles'] = $this->getRoles($user['id']);
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
	}
?>
