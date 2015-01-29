<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		 'items' => array()
	);

	foreach($_session->getAllowedRoles() as $role){
		$item =  array(
			  'uri'=> "$_moduleName/self/{$role}"
			, 'data' => $role
		);

		if(in_array($role, (array)$conf['authoz']['specialroles'])) $item['classes'] = array('md-warn');
		$json['items'][] = $item;
	}

	json_exit($json);
?>
