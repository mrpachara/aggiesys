<?php
	require_once "config.inc.php";

	require_once "inc.pdo.php";
	require_once "inc.user.php";
	require_once "inc.sessions.php";
	//require_once "inc.authen.php";
	//require_once "inc.authoz.php";
	//require_once "inc.pagestage.php";

	//require_once "inc.thdate.php";
	//require_once "inc.userdefined.php";

	session_cache_limiter('nocache');
	//header( 'Expires: Sat, 26 Jul 1997 05:00:00 GMT' );
	//header( 'Last-Modified: ' . gmdate( 'D, d M Y H:i:s' ) . ' GMT' );
	//header( 'Cache-Control: no-store, no-cache, must-revalidate' );
	//header( 'Cache-Control: post-check=0, pre-check=0', false );
	//header( 'Pragma: no-cache' );

	$_session = new \sys\Sessions(new \sys\UserService());
	if(empty($_SESSION[$conf['session']['gsessionNS']])) $_SESSION[$conf['session']['gsessionNS']] = array();

	if (function_exists('get_magic_quotes_gpc') && get_magic_quotes_gpc()) {
		function magicQuotes_awStripslashes(&$value, $key) {$value = stripslashes($value);}
		$gpc = array(&$_GET, &$_POST, &$_COOKIE, &$_REQUEST);
		array_walk_recursive($gpc, 'magicQuotes_awStripslashes');
	}

	if(!defined("PREVENT_TEMP_SESSION")){
		$_tmpsess = (!empty($_SESSION[$conf['session']['gsessionNS']]['__tmpsess']))? $_SESSION[$conf['session']['gsessionNS']]['__tmpsess'] : array();
		unset($_SESSION[$conf['session']['gsessionNS']]['__tmpsess']);

		$_SESSION[$conf['session']['gsessionNS']]['__tmpsess'] = array(
			'uri' => $_SERVER['REQUEST_URI'],
			'qs' => $_SERVER['QUERY_STRING']
		);

		$_ntmpsess =& $_SESSION[$conf['session']['gsessionNS']]['__tmpsess'];
	}
?>
