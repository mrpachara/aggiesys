<?php
	require_once "../../global.inc.php";

	$_session->authozPage("STAFF", "static::forbidden_json");

	require_once "include/config.php";
	require_once "include/etc.service.php";

	$entityService = new \app\EtcService();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		  'uri' => "{$_moduleName}/items/{$_GET['code']}"
		, 'links' => array()
		, 'items' => array()
	);

	//json_search($json);

	try{
		$data = $entityService->getByCode((!empty($_GET['code']))? $_GET['code'] : null);

		if($data === false){
			throw new Exception("{$_moduleName} whith code '{$_GET['code']}' not found", 404);
		}

		foreach($data['items'] as $dataitem){
			$item = array(
				  'uri' => "{$_moduleName}/items/{$data['code']}/{$dataitem['code']}"
				, 'value' => $dataitem['code']
				, 'label' => $dataitem['value']
				, 'data' => $dataitem
			);

			$json['items'][] = $item;
		}

		//json_page($json, $page);

		//$json['fields'] = $_fields;
	} catch(Exception $excp){
		$json['errors'] = array(
			  array(
			  	'exception' => ($excp instanceof \sys\DataServiceException)? new Exception(sprintf($excp->getMessage(), "{$_moduleName}/self/"), $excp->getCode(), $excp) : $excp
			)
		);
	}

	json_exit($json);
?>
