<?php
	define("PREVENT_TEMP_SESSION", true);
	//require_once "global.inc.php";
	require_once "config.inc.php";
	require_once "inc.pdo.php";
	require_once "inc.sessions.php";

	$_session = new \sys\Sessions();
?>
<a href="_session_destroy.php">session destroy</a>
<?php
	echo "<pre>";
	var_dump($_SESSION);
	echo "</pre>";
?>
