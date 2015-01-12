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
		}
	}

	function db_connect(){
		global $conf;
		$dbconf = $conf['db'];

		$mysqli = new mysqli($dbconf['host'], $dbconf['user'], $dbconf['password'], $dbconf['dbname']);

		if(!empty($dbconf['encoding'])) $mysqli->set_charset($dbconf['encoding']);
		/* The below command will automatically start transaction
		$mysqli->autocommit(false);
		*/

		return $mysqli;
	}

	function db_close($mysqli, $isCommit = null){
		if($isCommit !== null){
			if($isCommit){
				$mysqli->commit();
			} else{
				$mysqli->rollback();
			}
		}

		$mysqli->close();
	}
?>
