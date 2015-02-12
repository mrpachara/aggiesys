<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";
	require_once "include/etc.service.php";

	$entityService = new \app\EtcService();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		 'uri' => "{$_moduleName}/self".((!empty($_GET['id']))? "/{$_GET['id']}" : '' )
		,'links' => array()
	);

	try{
		$data = $entityService->get((!empty($_GET['id']))? $_GET['id'] : null);

		if($data === false){
			throw new Exception("{$_moduleName} whith id '{$_GET['id']}' not found", 404);
		}

		if($data['_updatable']){
			$json['links'][] =  array(
				 'rel' => (empty($data['id']))? 'create' : 'update'
				,'type' => 'submit'
				,'href' => "{$_modulePath}/update.php".((!empty($data['id']))? "?id={$data['id']}" : "")
				,'classes' => array("md-primary")
			);
		}

		if(!empty($data['id']) && ($data['_deletable'])){
			$json['links'][] =  array(
				 'rel' => 'delete'
				,'type' => 'get'
				,'href' => (!empty($data['id']))? "{$_modulePath}/delete.php?id={$data['id']}" : null
				,'classes' => array("md-warn")
				,'confirm' => array(
					 'title' => "Do you want to delete?"
					,'content' => "Your action cannot be undo."
				)
			);
		}

		if(empty($data['id'])) $json['mode'] = "create";

		$json['data'] = $data;

		$json['fields'] = $_fields;
	} catch(Exception $excp){
		$json['errors'] = array(
			  array(
			  	'exception' => ($excp instanceof \sys\DataServiceException)? new Exception(sprintf($excp->getMessage(), "{$_moduleName}/self/"), $excp->getCode(), $excp) : $excp
			)
		);
	}

	json_exit($json);
?>
