<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";
	require_once "include/user.service.php";

	$userService = new \app\UserService();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		 'uri' => "{$_moduleName}/list"
		,'links' => array(
			  array(
				  'rel' => 'new'
				, 'type' => 'view'
				, 'href' => $_moduleName."/self"
			)
		)
		,'items' => array()
	);

	json_search($json);

	try{
		$termText = (!empty($_GET['term']))? $_GET['term'] : null;
		$page = (!empty($_GET['page']))? $_GET['page'] : null;
		foreach($userService->getAll($termText, $page) as $data){
			$item = array(
				  'uri' => "{$_moduleName}/self/{$data['id']}"
				, 'value' => $data['id']
				, 'label' => $data['fullname']
				, 'links' => array()
				, 'data' => $data
			);

			$item['links'][] = array(
				  'rel' => 'self'
				, 'type' => 'view'
				, 'href' => "{$_moduleName}/self/{$data['id']}"
			);

			$json['items'][] = $item;
		}

		json_page($json, $page);

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
