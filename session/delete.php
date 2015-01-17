<?php
	require_once "../global.inc.php";

	$_session->authozPage('ADMIN', '\sys\Sessions::forbidden_json');

	header("Content-Type: application/json; charset=utf-8");

	$json = array(
		 'code' => 0
		,'message' => "Success to destroy session {$_GET['id']}"
	);
	if(!empty($_GET['id'])){
		if(!$_session->destroy($_GET['id'])){
			$json = array(
				 'error' => array(
					 'code' => 9002
					,'message' => "Cannot destroy session {$_GET['id']}!!!"
				)
			);
		}
	} else{
		$json = array(
			 'error' => array(
				 'code' => 9001
				,'message' => "Unknow session id!!!"
			)
		);
	}

	echo json_encode($json);
?>
