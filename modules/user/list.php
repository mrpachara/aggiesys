<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/user.service.php";

	$userService = new \app\UserService();

	$_modulePath = basename(__DIR__);
	$json = array(
		 'selfUrl' => "/{$_modulePath}/self"
		,'removeUrl' => "/{$_modulePath}/remove"
	);

	try{
		$json['items'] = $userService->getAll();
		$json['fields'] = array_diff(array_keys($json['items'][0]), ['id']);
	} catch(PDOException $excp){
		$json['errors'] = array(
			 'code' => $excp->getCode()
			,'message' => $excp->getMessage()
		);
	}

	header("Content-Type: application/json; charset=utf-8");
	echo json_encode($json);
?>
