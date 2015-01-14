<?php
	namespace sys;

	class Sessions implements \SessionHandlerInterface {
		private $pdo;
		private $excp = null;

		function __construct(){
			global $conf;

			$conf_session = $conf['session'];

			try{
				$this->pdo = new PDO();

				// Set handler to overide SESSION
				session_set_save_handler($this, true);

				session_name($conf_session['name']);
				if(!empty($conf_session['maxlifetime'])) ini_set('session.gc_maxlifetime', $conf_session['maxlifetime']);
				session_start();
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}
		}

		// return bool
		public function open($save_path, $name){
			echo "<pre>session->open</pre>";
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
			echo "<pre>session->read</pre>";
			if(empty($this->pdo) || !empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('SELECT * FROM "sessions" WHERE "id" = :id FOR UPDATE;');
				$stmt->execute(array(
					 ':id' => $session_id
				));
				$session = $stmt->fetch(\PDO::FETCH_ASSOC);
				return (!empty($session))? $session['data'] : null;
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return null;
		}

		// return bool
		public function write($session_id , $session_data){
			echo "<pre>session->write</pre>";
			if(empty($this->pdo) || !empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('UPDATE "sessions" SET "data" = :data, "tstmp" = CURRENT_TIMESTAMP WHERE "id" = :id;');
				$stmt->execute(array(
					 ':id' => $session_id
					,':data' => $session_data
				));
				if($stmt->rowCount() == 0){
					$stmt = $this->pdo->prepare('INSERT INTO "sessions" ("id", "data") VALUES (:id, :data);');
					$stmt->execute(array(
						 ':id' => $session_id
						,':data' => $session_data
					));
				}
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		// return bool
		public function destroy($session_id){
			echo "<pre>session->destroy</pre>";
			if(empty($this->pdo) || !empty($this->excp)) return false;

			try{
				$stmt = $this->pdo->prepare('DELETE FROM "sessions" WHERE "id" = :id;');
				$stmt->execute(array(
					 ':id' => $session_id
				));
			} catch(\PDOException $excp){
				$this->excp = $excp;
			}

			return false;
		}

		// return bool
		public function gc($maxlifetime){
			echo "<pre>session->gc</pre>";
			return true;
		}

		// return bool
		public function close(){
			echo "<pre>session->close</pre>";
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
	}
?>
