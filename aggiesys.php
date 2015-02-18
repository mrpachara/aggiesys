<?php
	require_once "global.inc.php";

	if(!$_session->authoz("ALL")){
		require "template/login.php";
	} else{
		require "template/app.php";
	}
?>
