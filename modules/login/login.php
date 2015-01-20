<?php
	require_once "../../global.inc.php";

	$json = array();
	if(!empty($_POST['username']) && !empty($_POST['password']) && $_session->login($_POST['username'], $_POST['password'])){
		$json = array(
			 'links' => array(
				 array(
					 'rel' => 'redirect'
					,'href' => '/dbtest'
				)
			)
		);
	} else{
		header("HTTP/1.1 {$conf['authoz']['forbidden_code']} invalid username or password or insufficient privilege");
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

	$json['post'] = $_POST;

	header("Content-Type: application/json; charset=utf-8");
	echo json_encode($json);
?>
