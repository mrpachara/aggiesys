<?php
	namespace sys;

	class UserService {
		private $pdo;

		function __construct(){
			$this->pdo = new PDO();
		}

		private function prepareUser($user){
			global $conf;

			$conf_authoz = $conf['authoz'];

			if(empty($user)) return $use;

			unset($user['password']);
			$roles = (!empty($conf_authoz['default']))? (array)$conf_authoz['default'] : array();

			if(!empty($user['id'])){
				$stmt = $this->pdo->prepare('SELECT * FROM "userrole" WHERE "id_user" = :id_user;');
				$stmt->execute(array(
					 ':id_user' => $user['id']
				));

				while($role = $stmt->fetch(\PDO::FETCH_ASSOC)){
					$roles[] = $role['role'];
				}

			}

			$user['roles'] = array_unique($roles);
			return $user;
		}

		public function getUser($id){
			if(empty($id)) return null;

			try{
				$stmt = $this->pdo->prepare('SELECT * FROM "user" WHERE "id" = :id;');
				$stmt->execute(array(
					 ':id' => $id
				));

				return $this->prepareUser($user = $stmt->fetch(\PDO::FETCH_ASSOC));
			} catch(\PDOException $excp){
			}

			return null;
		}

		public function getUserByUsernameAndPassword($username, $password){
			if(empty($username) || empty($password)) return null;

			try{
				$stmt = $this->pdo->prepare('SELECT * FROM "user" WHERE (("username" = :username) AND ("password" = crypt(:password, "password")));');
				$stmt->execute(array(
					 ':username' => $username
					,':password' => $password
				));

				return $this->prepareUser($stmt->fetch(\PDO::FETCH_ASSOC));
			} catch(\PDOException $excp){
			}

			return null;
		}
	}
?>
