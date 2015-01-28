<?php
	require_once "../../global.inc.php";

	$_session->authozPage('ADMIN', '\sys\Sessions::forbidden_json');

	header("Content-Type: application/json; charset=utf-8");

	$json = array();

	if(!empty($_GET['id'])){
		if(!$_session->destroy($_GET['id'])){
			$json = array(
				 'errors' => array(
					 array(
						 'code' => 505
						,'message' => "Cannot destroy session {$_GET['id']}!!!"
					)
				)
			);
		} else{
			$json['info'] = "Success to destroy session {$_GET['id']}";
			$json['isChanged'] = true;
		}
	} else{
		$json = array(
			 'errors' => array(
				 array(
					 'code' => 505
					,'message' => "Unknow session id!!!"
				)
			)
		);
	}

	if(!empty($json['errors'])){
		header("HTTP/1.1 {$json['errors']['code']} {$json['errors']['message']}");
	}

	header("Content-Type: application/json; charset=utf-8");
	exit(json_encode($json));
?>
