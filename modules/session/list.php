<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/include.php";

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		 'uri' => "{$_moduleName}/list"
		,'links' => array()
		,'items' => array()
	);
/*
	$json['links'][] = array(
		  'rel' => 'search'
	);
*/
	try{
		foreach($_session->getAll() as $data){
			$item = array(
				  'uri' => "{$_moduleName}/self/{$data['id']}"
				, 'value' => $data['id']
				, 'label' => $data['id']
				, 'links' => array()
				, 'data' => $data
			);

			$item['links'][] = array(
				  'rel' => 'delete'
				, 'type' => 'get'
				, 'href' => (session_id() == $data['id'])? null : $_modulePath."/delete.php?id={$data['id']}"
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
