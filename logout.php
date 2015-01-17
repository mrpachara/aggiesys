<?php
	require_once "global.inc.php";

	session_destroy();
	header("Location: {$conf['page']['login']}");
?>
