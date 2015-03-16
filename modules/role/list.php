<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/include.php";

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		  'uri' => "{$_moduleName}/list"
		, 'items' => array()
	);

	foreach($_session->getAllowedRoles() as $role){
		$item =  array(
			  'uri'=> "$_moduleName/self/{$role}"
			, 'value' => $role
			, 'label' => $role
			, 'data' => array(
				  'role' => $role
			)
		);

		if(in_array($role, (array)$conf['authoz']['specialroles'])) $item['classes'] = array('md-warn');
		$json['items'][] = $item;
	}

	$json['fields'] = $_fields;

	json_exit($json);
?>
