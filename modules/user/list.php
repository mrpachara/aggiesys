<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";
	require_once "include/user.service.php";

	$userService = new \app\UserService();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$_moduleUri = reflocation(__FILE__);

	$json = array(
		 'uri' => "{$_moduleName}/list"
		,'links' => array(
			 array(
				 'rel' => 'new'
				,'type' => 'view'
				,'href' => $_moduleName."/self"
			)
		)
		,'items' => array()
	);

	try{
		foreach($userService->getAll() as $data){
			$item = array(
				 'uri' => "{$_moduleName}/self/{$data['id']}"
				,'links' => array()
				,'data' => $data
			);

			$item['links'][] = array(
				 'rel' => 'self'
				,'type' => 'view'
				,'href' => "{$_moduleName}/self/{$data['id']}"
			);

			$json['items'][] = $item;
		}

		$json['fields'] = $_fields;
	} catch(Exception $excp){
		$json['errors'] = array(
			  array(
			  	'exception' => $excp
			)
		);
	}

	json_exit($json);
?>
