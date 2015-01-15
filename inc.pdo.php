<?php
	namespace sys;

	class PDO extends \PDO {
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
?>
