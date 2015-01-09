<?php
function &pagestage_create($pagename){
	global $conf;
	$sessionconf = $conf['session'];
	
	$_SESSION[$sessionconf['lsessionNS']]['page'][$pagename] = array(
		  'uri' => $_SERVER['REQUEST_URI']
		, 'qs' => $_SERVER['QUERY_STRING']
		, 'timestamp' => time()
	);
	
	return $_SESSION[$sessionconf['lsessionNS']]['page'][$pagename];
}

function &pagestage_get($pagename){
	global $conf;
	$sessionconf = $conf['session'];
	
	$_SESSION[$sessionconf['lsessionNS']]['page'][$pagename] = (array)$_SESSION[$sessionconf['lsessionNS']]['page'][$pagename];
	
	return $_SESSION[$sessionconf['lsessionNS']]['page'][$pagename];
}

function pagestage_destroy($pagename){
	global $conf;
	$sessionconf = $conf['session'];
	
	unset($_SESSION[$sessionconf['lsessionNS']]['page'][$pagename]);
}

function &pagestage_createTmp($pagename, &$pageid){
	$pageid = uniqid($pagename."#", true);
	
	return pagestage_create($pageid);
}

function &pagestage_retrievePageid($pagename, &$pageid, $isrefresh = true){
	global $conf;
	global $_tmpsess;
	global $_ntmpsess;
	
	$sessionconf = $conf['session'];
	$pagestageconf = $conf['pagestage'];
	
	$_pagestage = &pagestage_get($pagename);
	$_pagestage['__pageids'] = (array)$_pagestage['__pageids'];
	
	parse_str($_SERVER['QUERY_STRING'], $qss);
	$pageid = $qss['_pageid'];
	if(empty($qss['_pageid']) || empty($_pagestage['__pageids'][$qss['_pageid']])){
		if(count($_pagestage['__pageids']) >= $pagestageconf['maxpageid']) array_shift($_pagestage['__pageids']);
		$pageid = uniqid();
		
		$url_path = parse_url($_SERVER['REQUEST_URI'],PHP_URL_PATH);
		$qss['_pageid'] = $pageid;
		$newqs = http_build_query($qss);
		
		$_pagestage['__pageids'][$pageid] = array(
			  '_uri' => "{$url_path}?{$newqs}"
			, '_qs' => $newqs
			, '_timestamp' => time()
		);
		
		if($isrefresh){
			$_ntmpsess = $_tmpsess;
			
			header("Location: {$url_path}?{$newqs}");
			exit();
		}
	}
	
	return pagestage_getPageid($pagename, $pageid);
}

function &pagestage_getPageid($pagename, $pageid){
	global $conf;
	$sessionconf = $conf['session'];
	$pagestageconf = $conf['pagestage'];
	
	$_pagestage = &pagestage_get($pagename);
	$_pagestage['__pageids'] = (array)$_pagestage['__pageids'];
	
	if(!empty($_pagestage['__pageids'][$pageid])){
		$tmppageidstage = $_pagestage['__pageids'][$pageid];
		unset($_pagestage['__pageids'][$pageid]);
		$tmppageidstage['_timestamp'] = time();
		$_pagestage['__pageids'][$pageid] = $tmppageidstage;
	}
	
	return $_pagestage['__pageids'][$pageid];
}

function pagestage_destroyPageid($pagename, $pageid){
	global $conf;
	$sessionconf = $conf['session'];
	$pagestageconf = $conf['pagestage'];
	
	$_pagestage = &pagestage_get($pagename);
	$_pagestage['__pageids'] = (array)$_pagestage['__pageids'];
	
	$_returnpagestage = $_pagestage['__pageids'][$pageid];
	
	unset($_pagestage['__pageids'][$pageid]);
	
	return $_returnpagestage;
}
?>