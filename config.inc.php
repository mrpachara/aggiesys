<?php
	error_reporting(E_ALL);
	ini_set('display_errors', 1);

	require_once "BASEPATH.php";

	$conf = array();

	$conf['debug'] = 1;

	if($conf['debug'] == 0){
		error_reporting(0);
		ini_set('display_errors', 0);
	}

	$conf['app'] = array();
	$conf['app']['name'] = 'AggieSys';

	$conf['session'] = array();
	$conf['session']['name'] = 'AGGIESYSSESSION';
	$conf['session']['gsessionNS'] = '__GSESSION__';
	$conf['session']['gc_probability'] = 1;
	$conf['session']['gc_divisor'] = 100;
	$conf['session']['gc_maxlifetime'] = 10800;

	$conf['db'] = array();
	$conf['db']['host'] = 'localhost';
	$conf['db']['user'] = 'aggiesys';
	$conf['db']['password'] = 'a9d7C7Um';
	$conf['db']['dbname'] = 'aggiesys';
	$conf['db']['encoding'] = 'UTF-8';

	$conf['authen'] = array();
	$conf['authen']['sessionNS'] = 'user';

	$conf['authoz'] = array();
	$conf['authoz']['default'] = 'ALL';
	$conf['authoz']['superusername'] = 'root';
	$conf['authoz']['superuserrole'] = 'ROOT';
	$conf['authoz']['forbidden_code'] = 403;
	$conf['authoz']['forbidden_message'] = 'Forbidden';
	$conf['authoz']['allowedroles'] = array("MANAGER", "STAFF", "USER");
	$conf['authoz']['specialroles'] = array("ADMIN");

	$conf['page'] = array();
	$conf['page']['login'] = BASEPATH.'aggiesyslogin.php';
	$conf['page']['logout'] = BASEPATH.'logout.php';
	$conf['page']['main'] = BASEPATH.'aggiesys.php';

	$conf['pagestage'] = array();
	$conf['pagestage']['maxpageid'] = 20;

	$conf['pagination'] = array();
	$conf['pagination']['numofitem'] = 25;
	$conf['pagination']['numofshowedpage'] = 5;
	$conf['pagination']['previoustext'] = "ก่อนหน้า";
	$conf['pagination']['nexttext'] = "ถัดไป";
	$conf['pagination']['noprevioustext'] = "นี่เป็นหน้าแรก";
	$conf['pagination']['nonexttext'] = "นี่เป็นหน้าสุดท้าย";
	$conf['pagination']['currenttext'] = "นี่เป็นหน้าปัจจุบัน";
?>
