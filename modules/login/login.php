<?php
	require_once "../../global.inc.php";

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
