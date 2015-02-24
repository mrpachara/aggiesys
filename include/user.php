<?php
	namespace sys;

	class UserService {
		private $pdo;

		public static function encryptPassword($key){
			return "crypt({$key}, gen_salt('bf'))";
		}

		public static function decryptPassword($key){
			return "crypt({$key}, \"password\")";
		}

		function __construct(){
			$this->pdo = PDO::getInstance();
		}

		private function prepareUser($user){
			global $conf;

			$conf_authoz = $conf['authoz'];

			if(empty($user)) return $user;

			unset($user['password']);

			$roles = array();
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
				$stmt = $this->pdo->prepare('SELECT * FROM "user" WHERE ("id" = :id) AND (NOT "isterminated");');
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
				$stmt = $this->pdo->prepare('
					SELECT * FROM "user"
					WHERE
						    (("username" = :username)
						AND ("password" = '. static::decryptPassword(':password') .'))
						AND (NOT "isterminated")
				;');
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
