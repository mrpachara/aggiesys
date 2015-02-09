<?php
	require_once "../../global.inc.php";

	$_session->authozPage("STAFF", "static::forbidden_json");

	require_once "include/config.php";
	require_once "include/vegetable.service.php";

	$entityService = new \app\VegetableService();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		  'links' => array()
	);

	try{
		if($entityService->save((!empty($_GET['id']))? $_GET['id'] : null, $_POST)){
			$selfStatus = (empty($_GET['id']))? 'created' : 'updated';

			$json['statuses'] = array(
				  array(
					  'uri' => "{$_moduleName}/self/{$_POST['id']}"
					, 'status' => $selfStatus
				)
				, array(
					  'uri' => "{$_moduleName}/list"
					, 'status' => 'updated'
				)
			);

			$json['info'] = "{$_moduleName}/self/{$_POST['id']} was {$selfStatus}";
		}
	} catch(Exception $excp){
		$json['errors'] = array(
			  array(
			  	'exception' => ($excp instanceof \sys\DataServiceException)? new Exception(sprintf($excp->getMessage(), "{$_moduleName}/self/"), $excp->getCode(), $excp) : $excp
			)
		);
	}

	json_exit($json);
?>
