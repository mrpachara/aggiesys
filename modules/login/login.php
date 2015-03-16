<?php
	require_once "../../global.inc.php";

	require_once "include/include.php";

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array();
	if(!empty($_POST['username']) && !empty($_POST['password']) && $_session->login($_POST['username'], $_POST['password'])){
		$_session->create(session_id());

		$json = array(
			 'info' => "Login Success"
			,'links' => array(
				 array(
					 'rel' => 'main'
					,'type' => 'redirect'
					,'href' => '/user'
				)
			)
		);
	} else{
		$json = array(
			 'errors' => array(
				 array(
					 'code' => $conf['authoz']['forbidden_code']
					,'message' => 'invalid username or password or insufficient privilege'
				)
			)
		);
		session_destroy();
	}

	json_exit($json);
?>
