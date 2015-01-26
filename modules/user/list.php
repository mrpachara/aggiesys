<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";
	require_once "include/user.service.php";

	$userService = new \app\UserService();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		 'links' => array(
			 array(
				 'rel' => 'create'
				,'type' => 'view'
				,'href' => $_moduleName."/self"
			)
		)
		,'items' => array()
	);

	try{
		foreach($userService->getAll() as $data){
			$item = array(
				 'links' => array()
				,'data' => $data
			);

			$item['links'][] = array(
				 'rel' => 'self'
				,'type' => 'view'
				,'href' => "{$_moduleName}/self/{$data['id']}"
			);

			$item['links'][] = array(
				 'rel' => 'delete'
				,'type' => 'get'
				,'href' => "{$_modulePath}/delete.php?id={$data['id']}"
			);

			$json['items'][] = $item;
		}

		$json['fields'] = $_fields;
	} catch(Exception $excp){
		header("HTTP/1.1 {$excp->getCode()} {$excp->getMessage()}");
		$json['errors'] = array(
			 'code' => $excp->getCode()
			,'message' => $excp->getMessage()
		);
	}

	header("Content-Type: application/json; charset=utf-8");
	exit(json_encode($json));
?>
