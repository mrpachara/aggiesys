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
		$data = $userService->get((!empty($_GET['id']))? $_GET['id'] : null);

		if($data === false){
			throw new Exception("{$_moduleName}/self/{$_GET['id']} not found", 404);
		}

		if(!$data['_updatable']){
			throw new Exception("{$_moduleName}/self/{$_GET['id']} cannot be updated", 505);
		}

		if($userService->save($data['id'], $_POST)){
			$json['statuses'] = array(
				  array(
					  'uri' => "{$_moduleName}/self/{$_POST['id']}"
					, 'status' => (empty($data['id']))? 'created' : 'updated'
				)
				, array(
					  'uri' => "{$_moduleName}/list"
					, 'status' => 'updated'
				)
			);

			$json['info'] = "{$_moduleName}/self/{$_POST['id']} was updated";
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
