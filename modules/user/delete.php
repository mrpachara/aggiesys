<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";
	require_once "include/user.service.php";

	$userService = new \app\UserService();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		  'links' => array()
	);

	try{
		$data = $userService->get((!empty($_GET['id']))? $_GET['id'] : null);

		if($data === false){
			throw new Exception("{$_moduleName}/self/{$_GET['id']} not found", 404);
		}

		if(!$data['_deletable']){
			throw new Exception("{$_moduleName}/self/{$_GET['id']} cannot be deleted", 505);
		}

		if($userService->delete($data['id'])){
			$json['statuses'] = array(
				  array(
					  'uri' => "{$_moduleName}/self/{$data['id']}"
					, 'status' => 'deleted'
				)
				, array(
					  'uri' => "{$_moduleName}/list"
					, 'status' => 'updated'
				)
			);

			$json['info'] = "{$_moduleName}/self/{$data['id']} was deleted";
		}
	} catch(Exception $excp){
		$message = strtok($excp->getMessage(), "\n");
		header("HTTP/1.1 505 {$message}");
		$json['errors'] = array(
			  'code' => $excp->getCode()
			, 'message' => $excp->getMessage()
		);
	}

	header("Content-Type: application/json; charset=utf-8");
	exit(json_encode($json));
?>
