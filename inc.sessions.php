<?php
	namespace sys;

	if(!empty($conf['session']['gc_probability'])) ini_set('session.gc_probability', $conf['session']['gc_probability']);
	if(!empty($conf['session']['gc_divisor'])) ini_set('session.gc_divisor', $conf['session']['gc_divisor']);
	if(!empty($conf['session']['gc_maxlifetime'])) ini_set('session.gc_maxlifetime', $conf['session']['gc_maxlifetime']);

	class Sessions implements \SessionHandlerInterface {
		private $pdo;
		private $gc_maxlifetime;
		private $excp = null;
		private $user = null;

		function __construct(){
			global $conf;

			$conf_session = $conf['session'];

			echo "<pre>session->__construct:".time()."</pre>";
 			$this->gc_maxlifetime = ini_get('session.gc_maxlifetime');
			try{
				$this->pdo = new PDO();
				//echo "<pre>".time()."</pre>";

				// Set handler to overide SESSION
				session_set_save_handler($this, true);

				session_name($conf_session['name']);
				//echo "<pre>".time()."</pre>";
				session_start();
				//echo "<pre>".time()."</pre>";
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}
		}

		// return bool
		public function open($save_path, $name){
			echo "<pre>session->open:".time()."</pre>";
			if(empty($this->pdo)) return false;

			try{
				return $this->pdo->beginTransaction();
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		// return string
		public function read($session_id){
			echo "<pre>session->read:".time()."</pre>";
			if(empty($this->pdo) || !empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('SELECT * FROM "sessions" WHERE (("id" = :id) AND ("expires" > CURRENT_TIMESTAMP)) FOR UPDATE;');
				$stmt->execute(array(
					 ':id' => $session_id
				));
				$session = $stmt->fetch(\PDO::FETCH_ASSOC);

				if(!empty($session)){
					$stmt = $this->pdo->prepare('SELECT * FROM "user" WHERE "id" = :id;');
					$stmt->execute(array(
						 ':id' => $session['id_user']
					));
					$this->user = $stmt->fetch(\PDO::FETCH_ASSOC);
				}

				return (!empty($session))? $session['data'] : null;
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return null;
		}

		// return bool
		public function write($session_id , $session_data){
			echo "<pre>session->write:".time()."</pre>";
			if(empty($this->pdo) || !empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('UPDATE "sessions" SET "expires" = (CURRENT_TIMESTAMP + :maxlifetime::interval), "data" = :data, "id_user" = :id_user  WHERE "id" = :id;');
				$stmt->execute(array(
					 ':id' => $session_id
					,':maxlifetime' => $this->gc_maxlifetime.' second'
					,':data' => $session_data
					,':id_user' => (!empty($this->user['id_user']))? $this->user['id_user'] : null
				));
				if($stmt->rowCount() == 0){
					$stmt = $this->pdo->prepare('INSERT INTO "sessions" ("id", "expires", "data", "id_user") VALUES (:id, (CURRENT_TIMESTAMP + :maxlifetime::interval), :data, :id_user);');
					$stmt->execute(array(
						 ':id' => $session_id
						,':maxlifetime' => $this->gc_maxlifetime.' second'
						,':data' => $session_data
						,':id_user' => (!empty($this->user['id_user']))? $this->user['id_user'] : null
					));
				}

				return ($stmt->rowCount() == 1);
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		// return bool
		public function destroy($session_id){
			echo "<pre>session->destroy:".time()."</pre>";
			if(empty($this->pdo) || !empty($this->excp)) return false;

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
			echo "<pre>session->gc:".time()."</pre>";
			if(empty($this->pdo) || !empty($this->excp)) return false;

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
			echo "<pre>session->close:".time()."</pre>";
			if(empty($this->pdo)) return false;

			if(empty($this->excp)){
				echo "<pre>session->close(commit)</pre>";
				return $this->pdo->commit();
			} else{
				echo "<pre>session->close(rollBack)</pre>";
				echo "<pre>".($this->excp->getMessage())."</pre>";
				return $this->pdo->rollBack();
			}

			return false;
		}

		public function getUser(){
			return $this->user;
		}

		public function setUser($user = null){
			$this->user = $user;
		}
	}
?>
