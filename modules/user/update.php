<?php
	require_once "../../global.inc.php";

	$_session->authozPage("ADMIN", "static::forbidden_json");

	require_once "include/config.php";
	require_once "include/user.service.php";

	$userService = new \app\UserService();

	$_modulePath = reflocation(__DIR__);
	$_moduleName = basename(__DIR__);

	$json = array(
		  'links' => array()
	);

	try{
		if($userService->save((!empty($_GET['id']))? $_GET['id'] : null, $_POST)){
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

			$json['info'] = "{$_moduleName}/self/{$_POST['id']} {$selfStatus}";
		}
	} catch(Exception $excp){
		$json['errors'] = array(
			  array(
			  	'exception' => $excp
			)
		);
	}

	json_exit($json);
?>
