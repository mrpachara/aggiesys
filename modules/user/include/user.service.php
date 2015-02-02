<?php
	namespace app;

	class UserService extends \sys\DataService {
		protected static function getWhere(){
			global $conf;

			$where = array(
				  'sqls' => array()
				, 'params' => array()
			);

			if(!empty($conf['authoz']['superusername'])){
				$where['sqls'][] = '("username" <> :superuser)';
				$where['params'][':superuser'] = $conf['authoz']['superusername'];
			}

			$where['sqls'][] = '(NOT "isterminated")';

			return $where;
		}

		protected static function extendAction(&$data){
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
			parent::__construct();
		}

		private function getRoles($id_user){
			$stmt = $this->getPdo()->prepare('SELECT "role" FROM "userrole" WHERE "id_user" = :id_user ORDER BY "role" ASC;');
			$stmt->execute(array(
				  ':id_user' => $id_user
			));

			return $stmt->fetchAll(\PDO::FETCH_COLUMN);
		}

		protected function getEntity($id, $where){
			$data = false;
			if($id === null) {
				$data = array(
					  "id" => null
					, "username" => null
					, "fullname" => null
					, "roles" => array()
				);
			} else{
				$stmt = $this->getPdo()->prepare('
					SELECT
						  "id"
						, "username"
						, "fullname"
					FROM "user"
					'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $where['sqls']) : 'TRUE').'
				;');
				$stmt->execute($where['params']);

				$data = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($data['id'])){
					$data['roles'] = $this->getRoles($data['id']);
				}
			}

			return $data;
		}

		public function getAll($termText = null, &$page = null){
			$pageData = array(
				  'current' => null
				, 'previous' => null
				, 'next' => null
				, 'total' => null
			);

			$where = static::getWhere();

			$whereSearchTerm = static::getWhereSearchTerm(
				  array(
					  'username'
					, 'fullname'
					, 'userrole.role'
				)
				, static::getSearchTerm($termText)
			);


			$sqls = array_merge(
				  $where['sqls']
				, $whereSearchTerm['sqls']
			);

			$params = array_merge(
				  $where['params']
				, $whereSearchTerm['params']
			);

			$itemLimit = null;
			$limit = static::getLimit($page, $itemLimit);

			$sqlPattern = '
				SELECT DISTINCT
					  "user"."id" AS "id"
					, "user"."username" AS "username"
					, "user"."fullname" AS "fullname"
				FROM "user" LEFT JOIN "userrole" ON("user"."id" = "userrole"."id_user")
				'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $sqls) : '').'
				%s
			';

			if(!empty($page)){
				$stmt = $this->getPdo()->prepare(sprintf('
					SELECT count("_realdata".*) AS "numrows" FROM (%s) AS "_realdata";
				', sprintf($sqlPattern, '')));
				$stmt->execute($params);
				$pageData['total'] = ceil($stmt->fetchColumn() / $itemLimit);
			}

			$stmt = $this->getPdo()->prepare(sprintf($sqlPattern.';', 'ORDER BY "username" ASC '.$limit));
			$stmt->execute($params);

			$users = $stmt->fetchAll(\PDO::FETCH_ASSOC);

			if(!empty($page)){
				$pageData['current'] = $page;
			}

			if(!empty($page) && ($page > 1)){
				$pageData['previous'] = $page - 1;
			}

			if(!empty($page) && ($page < $pageData['total'])){
				$pageData['next'] = $page + 1;
			}

			foreach($users as &$user){
				if(!empty($user['id'])){
					$user['roles'] = $this->getRoles($user['id']);

					static::extendAction($user);
				}
			}

			if(!empty($page)) $page = $pageData;

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

			$this->getPdo()->beginTransaction();

			try{
				if($id === null){
					$stmt = $this->getPdo()->prepare('
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

					$id = $data['id'] = $this->getPdo()->lastInsertId('user_id_seq');
				} else{
					$stmt = $this->getPdo()->prepare('
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
					$stmt = $this->getPdo()->prepare('
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
				$stmt = $this->getPdo()->prepare('
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
					$stmt = $this->getPdo()->prepare('
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
				$this->getPdo()->rollBack();
				throw $excp;
			}

			return ($this->getPdo()->commit())? $id : false;
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

			$this->getPdo()->beginTransaction();

			try{
				$stmt = $this->getPdo()->prepare('
					DELETE FROM "user"
					WHERE "id" = :id
				;');
				$stmt->execute(array(
					  ':id' => $id
				));
			} catch(\PDOException $excp){
				$this->getPdo()->rollBack();
				throw $excp;
			}

			return ($this->getPdo()->commit())? $id : false;
		}
	}
?>
