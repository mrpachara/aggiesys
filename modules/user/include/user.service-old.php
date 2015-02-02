<?php
	namespace app;

	class UserService {
		private $pdo;

		private static function getWhere(){
			global $conf;

			$where = array(
				  'sqls' => array()
				, 'param' => array()
			);

			if(!empty($conf['authoz']['superusername'])){
				$where['sqls'][] = '("username" <> :superuser)';
				$where['param'][':superuser'] = $conf['authoz']['superusername'];
			}

			return $where;
		}

		private static function extendAction(&$data){
			global $conf;

			if(empty($data)) return;

			$data['_updatable'] = (
				   ($data['id'] == $GLOBALS['_session']->getUser()['id'])
				|| (
					   (!empty($conf['authoz']['superusername']))
					&& ($conf['authoz']['superusername'] == $GLOBALS['_session']->getUser()['username'])
				)
				|| (
					(count(
						  array_intersect($data['roles']
						, (!empty($conf['authoz']['specialroles']))? (array)$conf['authoz']['specialroles'] : array())
					) == 0)
				)
			);

			$data['_deletable'] = (
				   ($data['id'] != $GLOBALS['_session']->getUser()['id'])
				&& (
					   (
						   (!empty($conf['authoz']['superusername']))
						&& ($conf['authoz']['superusername'] == $GLOBALS['_session']->getUser()['username'])
					)
					|| (count(
						  array_intersect($data['roles']
						, (!empty($conf['authoz']['specialroles']))? (array)$conf['authoz']['specialroles'] : array())
					) == 0)
				)
			);
		}

		function __construct(){
			$this->pdo = new \sys\PDO();
		}

		private function getRoles($id_user){
			$stmt = $this->pdo->prepare('SELECT "role" FROM "userrole" WHERE "id_user" = :id_user ORDER BY "role" ASC;');
			$stmt->execute(array(
				  ':id_user' => $id_user
			));

			return $stmt->fetchAll(\PDO::FETCH_COLUMN);
		}

		public function get($id = null){
			$user = null;
			if($id === null) {
				$user = array(
					  "id" => null
					, "username" => null
					, "fullname" => null
					, "roles" => array()
				);
			} else{
				$where = static::getWhere();

				$stmt = $this->pdo->prepare('
					SELECT
						  "id"
						, "username"
						, "fullname"
					FROM "user"
					WHERE ("id" = :id) AND '.((!empty($where))? implode(' AND ', $where['sqls']) : 'TRUE').'
				;');
				$stmt->execute(array_merge(
					  array(
						 ':id' => $id
					)
					, $where['param']
				));

				$user = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($user['id'])){
					$user['roles'] = $this->getRoles($user['id']);
				}
			}

			static::extendAction($user);

			return $user;
		}

		public function getAll(){
			$where = static::getWhere();

			$stmt = $this->pdo->prepare('
				SELECT
					  "id"
					, "username"
					, "fullname"
				FROM "user"
				'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : '').'
				ORDER BY "username" ASC
			;');
			$stmt->execute($where['param']);

			$users = $stmt->fetchAll(\PDO::FETCH_ASSOC);

			foreach($users as &$user){
				if(!empty($user['id'])){
					$user['roles'] = $this->getRoles($user['id']);

					static::extendAction($user);
				}
			}

			return $users;
		}

		public function save($id, &$data){
			if(empty($data)) return false;

			$existedData = $this->get($id);

			if($existedData === false){
				throw new Exception("{$_moduleName}/self/{$_GET['id']} not found", 404);
			}

			if(!$existedData['_updatable']){
				throw new Exception("{$_moduleName}/self/{$_GET['id']} cannot be updated", 500);
			}

			$id = $existedData['id'];

			$this->pdo->beginTransaction();

			try{
				if($id === null){
					$stmt = $this->pdo->prepare('
						INSERT INTO "user" (
							  "username"
							, "fullname"
							, "password"
						) VALUES (
							  :username
							, :fullname
							, :password
						)
					;');
					$stmt->execute(array(
						  ':username' => $data['username']
						, ':fullname' => $data['fullname']
						, ':password' => ''
					));

					$id = $data['id'] = $this->pdo->lastInsertId('user_id_seq');
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
						, ':fullname' => $data['fullname']
						, ':id' => $id
					));

					$data['id'] = $id;
				}

				if(!empty($data['password'])){
					$stmt = $this->pdo->prepare('
						UPDATE "user" SET
							  "password" = '.\sys\UserService::encryptPassword(':password').'
						WHERE
							"id" = :id
					;');
					$stmt->execute(array(
						  ':password' => $data['password']
						, ':id' => $id
					));
				}

				$allowedRoles = $GLOBALS['_session']->getAllowedRoles();

				$paramIn = array();
				$stmt = $this->pdo->prepare('
					DELETE FROM "userrole"
					WHERE ("id_user" = :id_user) AND ("role" IN ('.\sys\PDO::prepareIn(':role', $allowedRoles, $paramIn).'))
				;');
				$stmt->execute(array_merge(
					  array(
						  ':id_user' => $id
					)
					, $paramIn
				));

				if(!empty($data['roles'])){
					$data['roles'] = array_intersect($data['roles'], $allowedRoles);
					$stmt = $this->pdo->prepare('
						INSERT INTO "userrole" (
							  "id_user"
							, "role"
						) VALUES (
							  :id_user
							, :role
						)
					;');

					foreach($data['roles'] as $role){
						$stmt->execute(array(
							  ':id_user' => $id
							, ':role' => $role
						));
					}
				}
			} catch(\PDOException $excp){
				$this->pdo->rollBack();
				throw $excp;
			}

			return ($this->pdo->commit())? $id : false;
		}

		public function delete($id){
			if(empty($id)) return false;

			$existedData = $this->get($id);

			if($existedData === false){
				throw new Exception("{$_moduleName}/self/{$_GET['id']} not found", 404);
			}

			if(!$existedData['_updatable']){
				throw new Exception("{$_moduleName}/self/{$_GET['id']} cannot be deleted", 500);
			}

			$id = $existedData['id'];

			$this->pdo->beginTransaction();

			try{
				$stmt = $this->pdo->prepare('
					DELETE FROM "user"
					WHERE "id" = :id
				;');
				$stmt->execute(array(
					  ':id' => $id
				));
			} catch(\PDOException $excp){
				$this->pdo->rollBack();
				throw $excp;
			}

			return ($this->pdo->commit())? $id : false;
		}
	}
?>
