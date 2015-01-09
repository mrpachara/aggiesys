<?php
	define("PREVENT_TEMP_SESSION", true);
	require_once "global.inc.php";
?>
<a href="_session_destroy.php">session destroy</a>
<?php
	echo "<pre>";
	var_dump($_SESSION);
	echo "</pre>";
?>