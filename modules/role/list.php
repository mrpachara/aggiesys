<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		 'items' => array()
	);

	$allowedroles = array_merge(
		 (array)$conf['authoz']['allowedroles']
		,($_session->authoz($conf['authoz']['superuserrole']))? (array)$conf['authoz']['specialroles'] : array()
	);

	foreach($allowedroles as $role){
		$item =  array(
			 'data' => $role
		);

		if(in_array($role, (array)$conf['authoz']['specialroles'])) $item['classes'] = array('md-warn');
		$json['items'][] = $item;
	}

	header("Content-Type: application/json; charset=utf-8");
	echo json_encode($json);
?>
