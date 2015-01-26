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

		$json['links'][] =  array(
			 'rel' => 'update'
			,'type' => 'post'
			,'href' => "{$_modulePath}/update.php"
		);

		$json['links'][] =  array(
			 'rel' => 'delete'
			,'type' => 'get'
			,'href' => (!empty($data['id']))? "{$_modulePath}/delete.php?id={$data['id']}" : null
		);

		$json['data'] = $data;

		$json['fields'] = $_fields;
	} catch(Exception $excp){
		$json['errors'] = array(
			 'code' => $excp->getCode()
			,'message' => $excp->getMessage()
		);
	}

	header("Content-Type: application/json; charset=utf-8");
	echo json_encode($json);
?>
