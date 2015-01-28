<?php
	namespace sys;

	class UserService {
		private $pdo;

		static function encryptPassword(){
			return "crypt(:password, gen_salt('bf'))";
		}

		static function decryptPassword(){
			return "crypt(:password, "password")";
		}

		function __construct(){
			$this->pdo = new PDO();
		}

		private function prepareUser($user){
			global $conf;

			$conf_authoz = $conf['authoz'];

			if(empty($user)) return $user;

			unset($user['password']);

			// MUSE move to session
			$roles = array_merge(
				 (!empty($conf_authoz['default']))? (array)$conf_authoz['default'] : array()
				,(($user['username'] == $conf_authoz['superusername']) && !empty($conf_authoz['superuserrole']))? (array)$conf_authoz['superuserrole'] : array()
			);

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
				$stmt = $this->pdo->prepare('SELECT * FROM "user" WHERE (("username" = :username) AND ("password" = '. static::decryptPassword() .'));');
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
