<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	$_modulePath = basename(__DIR__);
	$json = array(
		 'selfUrl' => "/{$_modulePath}/self"
		,'removeUrl' => "/{$_modulePath}/remove"
	);

	try{
		$json['items'] = $_session->getAll();
		$json['fields'] = array_keys($json['items'][0]);
	} catch(PDOException $excp){
		$json['errors'] = array(
			 'code' => $excp->getCode()
			,'message' => $excp->getMessage()
		);
	}

	header("Content-Type: application/json; charset=utf-8");
	echo json_encode($json);
?>
