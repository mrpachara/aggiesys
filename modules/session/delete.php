<?php
	require_once "../../global.inc.php";

	$_session->authozPage('ADMIN', '\sys\Sessions::forbidden_json');

	$json = array();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	if(!empty($_GET['id'])){
		if(!$_session->destroy($_GET['id'])){
		//if(!true){
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
			$json['statuses'] = array(
				 array(
					 'uri' => "{$_moduleName}/self/{$_GET['id']}"
					,'status' => 'deleted'
				)
				,array(
					'uri' => "{$_moduleName}/list"
					,'status' => 'updated'
				)
			);
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
		header("HTTP/1.1 {$json['errors'][0]['code']} {$json['errors'][0]['message']}");
	}

	header("Content-Type: application/json; charset=utf-8");
	exit(json_encode($json));
?>
