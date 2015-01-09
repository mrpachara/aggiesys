<?php
	require_once "global.inc.php";
	
	session_destroy();
	
	header("Location: _session.php");
?>