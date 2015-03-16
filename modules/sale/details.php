<?php
	require_once "../../global.inc.php";

	$_session->authozPage("STAFF", "static::forbidden_json");

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$detailMap = array();
	foreach($_POST as $delivery){
		if(!empty($delivery['details'])){
			foreach($delivery['details'] as $detail){
				if(empty($detailMap[$detail['vegetable']['code']])){
					$detailMap[$detail['vegetable']['code']] = $detail;
					unset($detailMap[$detail['vegetable']['code']]['price']);
				} else{
					$detailMap[$detail['vegetable']['code']]['qty'] += $detail['qty'];
				}
			}
		}
	}

	ksort($detailMap);

	$json = array();
	foreach($detailMap as $detail){
		$json[] = $detail;
	}

	json_exit($json);
?>
