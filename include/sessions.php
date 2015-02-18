<?php
	namespace sys;

	if(!empty($conf['session']['gc_probability'])) ini_set('session.gc_probability', $conf['session']['gc_probability']);
	if(!empty($conf['session']['gc_divisor'])) ini_set('session.gc_divisor', $conf['session']['gc_divisor']);
	if(!empty($conf['session']['gc_maxlifetime'])) ini_set('session.gc_maxlifetime', $conf['session']['gc_maxlifetime']);

	class Sessions implements \SessionHandlerInterface {
		private $pdo;
		private $userService;
		private $excp = null;
		private $user = null;

		public static function forbidden_html($code, $message){
			global $conf;

			header("Content-Type: text/html; charset=utf-8");

			return $message."<br /><a href=\"{$conf['page']['login']}\">Longin or Switch user</a>";
		}

		public static function forbidden_json($code, $message){
			header("Content-Type: application/json; charset=utf-8");

			return json_encode(array(
				  'errors' => array(
					  array(
						  'code' => $code
						, 'message' => $message
					)
				)
			));
		}

		private static function extendSessoinRole(&$user){
			global $conf;

			if(empty($user)) return;

			$user['roles'] = array_merge(
				  (!empty($user['roles']))? (array)$user['roles'] : array()
				, (!empty($conf['authoz']['default']))? (array)$conf['authoz']['default'] : array()
				, (($user['username'] == $conf['authoz']['superusername']) && !empty($conf['authoz']['superuserrole']))? (array)$conf['authoz']['superuserrole'] : array()
			);

			$user['roles'] = array_unique($user['roles']);
		}

		function __construct($userService){
			global $conf;

			$conf_session = $conf['session'];

			//echo "<pre>session->__construct:".time()."</pre>";
			$this->pdo = new PDO();
			$this->userService = $userService;

			// Set handler to overide SESSION
			session_set_save_handler($this, true);

			session_name($conf_session['name']);
			//echo "<pre>".time()."</pre>";
			session_start();
			//echo "<pre>".time()."</pre>";
		}

		// return bool
		public function open($save_path, $name){
			//echo "<pre>session->open:".time()."</pre>";
			if(!empty($this->excp)) return false;

			try{
				return $this->pdo->beginTransaction();
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		// return string
		public function read($session_id){
			//echo "<pre>session->read:".time()."</pre>";
			if(!empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('SELECT * FROM "sessions" WHERE (("id" = :id) AND ("expires" > CURRENT_TIMESTAMP)) FOR UPDATE;');
				$stmt->execute(array(
					  ':id' => $session_id
				));
				$session = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($session['id_user'])){
					$this->user = $this->userService->getUser($session['id_user']);
					static::extendSessoinRole($this->user);
				}

				return (!empty($session))? $session['data'] : null;
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return null;
		}

		// return bool
		public function write($session_id , $session_data){
			//echo "<pre>session->write:".time()."</pre>";
			if(!empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('UPDATE "sessions" SET "expires" = (CURRENT_TIMESTAMP + :maxlifetime::interval), "data" = :data, "id_user" = :id_user  WHERE "id" = :id;');
				$stmt->execute(array(
					  ':id' => $session_id
					, ':maxlifetime' => ini_get('session.gc_maxlifetime').' second'
					, ':data' => $session_data
					, ':id_user' => (!empty($this->user['id']))? $this->user['id'] : null
				));

				return ($stmt->rowCount() == 1);
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		// return bool
		public function destroy($session_id){
			//echo "<pre>session->destroy({$session_id}):".time()."</pre>";
			if(!empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('DELETE FROM "sessions" WHERE "id" = :id;');
				$stmt->execute(array(
					  ':id' => $session_id
				));

				return ($stmt->rowCount() == 1);
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		// return bool
		public function gc($maxlifetime){
			//echo "<pre>session->gc:".time()."</pre>";
			if(!empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('DELETE FROM "sessions" WHERE "expires" < CURRENT_TIMESTAMP;');
				$stmt->execute();

				return true;
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		// return bool
		public function close(){
			//echo "<pre>session->close:".time()."</pre>";
			$return = null;
			if(empty($this->excp)){
				//echo "<pre>session->close(commit)</pre>";
				$return = $this->pdo->commit();
			} else{
				//echo "<pre>session->close(rollBack)</pre>";
				//echo "<pre>".($this->excp->getMessage())."</pre>";
				$return = $this->pdo->rollBack();
			}
			$this->pdo = null;

			return $return;
		}

		public function getAll($page = null, $search = null){
			if(!empty($this->excp)) return;

			$stmt = $this->pdo->prepare('SELECT "sessions"."id", "expires", "user"."username", "user"."id" as id_user FROM "sessions" LEFT JOIN "user" ON("sessions"."id_user" = "user"."id")');
			$stmt->execute();

			return $stmt->fetchAll(\PDO::FETCH_ASSOC);
		}

		public function create($session_id){
			//echo "<pre>session->create:".time()."</pre>";
			if(!empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('DELETE FROM "sessions" WHERE "id" = :id;');
				$stmt->execute(array(
					  ':id' => $session_id
				));

				$stmt = $this->pdo->prepare('INSERT INTO "sessions" ("id") VALUES (:id);');
				$stmt->execute(array(
					  ':id' => $session_id
				));

				return ($stmt->rowCount() == 1);
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		public function getUser(){
			return $this->user;
		}

		public function login($username, $password){
			if(!empty($this->excp)) return false;

			$this->user = $this->userService->getUserByUsernameAndPassword($username, $password);
			static::extendSessoinRole($this->user);

			return !empty($this->user);
		}

		public function authoz($roles = null){
			global $conf;

			if(($roles === null) && !empty($conf['authoz']['default'])) $roles = (array)$conf['authoz']['default'];
			$roles = (array)$roles;

			if(!empty($conf['authoz']['superuserrole'])) $roles = array_merge($roles, (array)$conf['authoz']['superuserrole']);

			$tmpintersect = null;
			if(!empty($this->user)) $tmpintersect = array_intersect($roles, (array)$this->user['roles']);

			return !empty($tmpintersect);
		}

		function authozPage($roles = null, $message_func = null){
			global $conf;

			if(!$this->authoz($roles)){
				header("HTTP/1.1 {$conf['authoz']['forbidden_code']} {$conf['authoz']['forbidden_message']}");
				exit(call_user_func(($message_func === null)? 'static::forbidden_html' : $message_func, $conf['authoz']['forbidden_code'], $conf['authoz']['forbidden_message']));
			}
		}

		function getAllowedRoles(){
			global $conf;

			return array_merge(
				  (array)$conf['authoz']['allowedroles']
				, ($this->authoz($conf['authoz']['superuserrole']))? (array)$conf['authoz']['specialroles'] : array()
			);
		}
	}
?>
