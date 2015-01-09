<?php
	function authen_login($mysqli, $username, $password){
		global $conf;
		$sessionconf = $conf['session'];
		$authenconf = $conf['authen'];
		$authozconf = $conf['authoz'];
		
		$stmt = $mysqli->prepare("
			SELECT
				  *
			FROM
				`user`
			WHERE
				(`user`.`username` = ?) AND (`user`.`passwd` = SHA1(?)) AND (`user`.`isterminated` = FALSE)
			LIMIT 0, 1
		");
		$stmt->bind_param("ss", $username, $password);
		$stmt->execute();
		$userresult = $stmt->get_result();
		$stmt->close();
		
		if($user = $userresult->fetch_assoc()){
			unset($user['passwd']);
			$user['roles'] = array_merge(
				  (array)$authozconf['default']
				, (($user['username'] === $authozconf['superusername']) && !empty($authozconf['superuserrole']))? (array)$authozconf['superuserrole'] : array()
			);
			
			$stmt = $mysqli->prepare("
				SELECT
					  `role`.`code` AS 'code'
				FROM
					`user_role` LEFT JOIN `role` ON `user_role`.`id_role` = `role`.`id`
				WHERE
					`user_role`.`id_user` = ?
			");
			$stmt->bind_param('d', $user['id']);
			$stmt->execute();
			$roleresult = $stmt->get_result();
			$stmt->close();
			
			while($role = $roleresult->fetch_assoc()){
				$user['roles'][] = $role['code'];
			}
			
			$user['roles'] = array_unique($user['roles']);
			
			$_SESSION[$sessionconf['lsessionNS']] = array(
				$authenconf['sessionNS'] => $user
			);
		}
		
		return $user;
	}
	
	function authen_logout(){
		global $conf;
		$authenconf = $conf['authen'];
		$sessionconf = $conf['session'];
		
		unset($_SESSION[$sessionconf['lsessionNS']]);
	}
	
	function authen_getUser(){
		global $conf;
		$authenconf = $conf['authen'];
		$sessionconf = $conf['session'];
		
		return $_SESSION[$sessionconf['lsessionNS']][$authenconf['sessionNS']];
	}
?>