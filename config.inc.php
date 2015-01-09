<?php
	require_once "BASEPATH.php";
	
	$conf = array();
	
	$conf['session'] = array();
	$conf['session']['name'] = 'LOTTOSESSION';
	$conf['session']['lsessionNS'] = 'LSESSION';
	$conf['session']['gsessionNS'] = 'GSESSION';
	$conf['session']['maxlifetime'] = 10800;
	
	$conf['db'] = array();
	$conf['db']['host'] = 'localhost';
	$conf['db']['user'] = 'lotto';
	$conf['db']['password'] = 'yEEP2f5aHsFKsPZ9';
	$conf['db']['dbname'] = 'lotto_lotto';
	$conf['db']['encoding'] = 'UTF-8';
	
	$conf['authen'] = array();
	$conf['authen']['sessionNS'] = 'user';
	
	$conf['authoz'] = array();
	$conf['authoz']['default'] = 'ALL';
	$conf['authoz']['superusername'] = 'su';
	$conf['authoz']['superuserrole'] = 'SUPERUSER';
	$conf['authoz']['forbidden_code'] = 403;
	$conf['authoz']['forbidden_message'] = 'Forbidden';
	
	$conf['page'] = array();
	$conf['page']['login'] = 'login.php';
	$conf['page']['logout'] = 'logout.php';
	$conf['page']['main'] = 'main.php';
	
	$conf['pagestage'] = array();
	$conf['pagestage']['maxpageid'] = 20;
	
	$conf['pagination'] = array();
	$conf['pagination']['numofitem'] = 20;
	$conf['pagination']['numofshowedpage'] = 5;
	$conf['pagination']['previoustext'] = "ก่อนหน้า";
	$conf['pagination']['nexttext'] = "ถัดไป";
	$conf['pagination']['noprevioustext'] = "นี่เป็นหน้าแรก";
	$conf['pagination']['nonexttext'] = "นี่เป็นหน้าสุดท้าย";
	$conf['pagination']['currenttext'] = "นี่เป็นหน้าปัจจุบัน";
?>