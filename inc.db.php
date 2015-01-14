<?php
	namespace sys;

	class PDO extends \PDO {
		function __construct($dsn = null){
			global $conf;

			$conf_db = $conf['db'];

			if($dsn === null){
				$dsn = "pgsql:host={$conf_db['host']};dbname={$conf_db['dbname']};user={$conf_db['user']};password={$conf_db['password']}";
			}

			parent::__construct($dsn);

			//$this->setAttribute(PDO::ATTR_STATEMENT_CLASS, array('sys\PDOStatment', array($this)));
			$this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		}
	}
?>
