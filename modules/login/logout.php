<?php
	require_once "../../global.inc.php";

	require_once "include/include.php";

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	session_destroy();

	json_exit(array(
		  'statuses' => array(
			  array(
				  'uri' => "$_moduleName"
				, 'status' => "logout"
			)
		)
	));
?>
