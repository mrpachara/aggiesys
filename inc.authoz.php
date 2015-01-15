<?php
	function authoz_grant($roles = null){
		global $conf;
		$sessionconf = $conf['session'];
		$authozconf = $conf['authoz'];

		$roles = (array)$roles;
		if(!empty($authozconf['superuserrole'])) $roles = array_merge($roles, (array)$authozconf['superuserrole']);

		$tmpintersect = null;
		$user = authen_getUser();
		if(!empty($user)) $tmpintersect = array_intersect($roles,(array)$user['roles']);

		return (!empty($tmpintersect));
	}

	function authoz_grantpage($roles, &$errors){
		global $conf;
		$authozconf = $conf['authoz'];
		$pageconf = $conf['page'];

		if(!authoz_grant($roles)){
			$errors = (array)$errors;
			$errors[] = "Access Denie!!!";
			header("HTTP/1.1 {$authozconf['forbidden_code']} {$authozconf['forbidden_message']}");
			//header("Location: {$pageconf['login']}");
			exit($authozconf['forbidden_message']."<br /><a href=\"{$pageconf['login']}\">longin or switch user</a>");
			//exit($authozconf['forbidden_message']);
		}
	}
?>
