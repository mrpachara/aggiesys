<?php
	namespace sys;

	class Sessions {
		private $pdo;

		function __contruct(){
			global $conf;

			$this->pdo = new PDO();

			// Set handler to overide SESSION
			session_set_save_handler(
				array($this, "_open"),
				array($this, "_close"),
				array($this, "_read"),
				array($this, "_write"),
				array($this, "_destroy"),
				array($this, "_gc")
			);
		}

		public function _open(){
			
		}
	}
?>
