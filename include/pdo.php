<?php
	namespace sys;

	class PDOConfigurated extends \PDO {
		function __construct($dsn = null, $user = null, $password = null, $option = null){
			global $conf;

			$conf_db = $conf['db'];

			if($dsn === null){
				$dsn = "pgsql:host={$conf_db['host']};dbname={$conf_db['dbname']};user={$conf_db['user']};password={$conf_db['password']}";
			}

			//echo "<pre>PDO:".time().":".date("Y-m-d H:i:s")."</pre>";
			parent::__construct($dsn, $user, $password, (array)$option + array(
				 \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION)
				// \PDO::ATTR_ERRMODE => \PDO::ERRMODE_WARNING
			);
			//echo "<pre>PDO:".time().":".date("Y-m-d H:i:s")."</pre>";
		}
	}

	class PDO {
		public static function prepareIn($key, $values, &$param = array()){
			$keys = array();

			for($i = 0; $i < count($values); $i++){
				$i_key = $key.'_'.$i;
				$keys[] = $i_key;
				$param[$i_key] = $values[$i];
			}

			return implode(', ', $keys);
		}


		public static function getJsDate($field){
			return "to_char({$field}::timestamp with time zone at time zone 'Z', 'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"')";
		}

		public static function getInstance(){
			static $instance = null;

			if (null === $instance) {
				$instance = new PDOConfigurated();
			}

			return $instance;
		}

		protected function __construct(){
		}

		/**
		 * Private clone method to prevent cloning of the instance of the
		 * *Singleton* instance.
		 *
		 * @return void
		 */
		private function __clone(){
		}

		/**
		 * Private unserialize method to prevent unserializing of the *Singleton*
		 * instance.
		 *
		 * @return void
		 */
		private function __wakeup(){
		}
	}
?>
