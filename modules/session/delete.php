<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/include.php";

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	if(!empty($_GET['id'])){
		if(!$_session->destroy($_GET['id'])){
		//if(!true){
			$json = array(
				 'errors' => array(
					 array(
						 'code' => 500
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
					 'code' => 500
					,'message' => "Unknow session id!!!"
				)
			)
		);
	}

	json_exit($json);
?>
