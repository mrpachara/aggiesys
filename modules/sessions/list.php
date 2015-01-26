<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		 'links' => array()
		,'items' => array()
	);

	try{
		foreach($_session->getAll() as $data){
			$item = array(
				 'links' => array()
				,'data' => $data
			);

			$item['links'][] = array(
				 'rel' => 'delete'
				,'type' => 'get'
				,'href' => (session_id() == $data['id'])? null : $_modulePath."/delete.php?id={$data['id']}"
			);

			$json['items'][] = $item;
		}

		$json['fields'] = array('id', 'expires', 'username');
	} catch(PDOException $excp){
		$json['errors'] = array(
			 'code' => $excp->getCode()
			,'message' => $excp->getMessage()
		);
	}

	header("Content-Type: application/json; charset=utf-8");
	echo json_encode($json);
?>
