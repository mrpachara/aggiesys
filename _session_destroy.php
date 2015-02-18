<?php
	//require_once "global.inc.php";
	require_once "config.inc.php";
	require_once "include/pdo.php";
	require_once "include/user.php";
	require_once "include/sessions.php";

	$_session = new \sys\Sessions(new \sys\UserService());

	session_destroy();

	header("Location: _session.php");
?>
