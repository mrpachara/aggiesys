<?php
	function db_connect(){
		global $conf;
		$dbconf = $conf['db'];
		
		$mysqli = new mysqli($dbconf['host'], $dbconf['user'], $dbconf['password'], $dbconf['dbname']);
		
		if(!empty($dbconf['encoding'])) $mysqli->set_charset($dbconf['encoding']);
		/* The below command will start transaction automatically
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