<?php
	//require_once "global.inc.php";
	require_once "config.inc.php";
	require_once "inc.pdo.php";
	require_once "inc.sessions.php";

	$_session = new \sys\Sessions();

	session_destroy();

	header("Location: _session.php");
?>
