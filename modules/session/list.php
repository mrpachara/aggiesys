<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$_moduleUri = reflocation(__FILE__);

	$json = array(
		 'uri' => "{$_moduleName}/list"
		,'links' => array()
		,'items' => array()
	);

	try{
		foreach($_session->getAll() as $data){
			$item = array(
				 'uri' => "{$_moduleName}/self/{$data['id']}"
				,'links' => array()
				,'data' => $data
			);

			$item['links'][] = array(
				 'rel' => 'delete'
				,'type' => 'get'
				,'href' => (session_id() == $data['id'])? null : $_modulePath."/delete.php?id={$data['id']}"
			);

			$json['items'][] = $item;
		}

		$json['fields'] = $_fields;
	} catch(PDOException $excp){
		$json['errors'] = array(
			  array(
			  	'exception' => $excp
			)
		);
	}

	json_exit($json);
?>
