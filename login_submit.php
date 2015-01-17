<?php
	require_once "global.inc.php";

	if($_session->login($_POST['username'], $_POST['password'])){
		header("Location: dbtest.php");
	} else{
		$_ntmpsess['errors'] = array(
			 array(
				 'code' => 99
				,'message' => "Login Fail!!!"
			)
		);
		header("Location: login.php");
	}
?>
