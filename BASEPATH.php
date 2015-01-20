<?php
	/*
		IMPOTENT: THIS FILE MUST PUT ON ROOT DIRECTORY OF APPLICATION.
	*/
	function localpath($file){
		return preg_replace('/^'.preg_replace('/\//', '\/', preg_quote(BASEPATH)).'/', '', $file);
	}

	function reflocation($absoulteLocalPath){
		return preg_replace('/^'.preg_replace('/\//', '\/', preg_quote(LOCALPATH)).'/', BASEPATH, $absoulteLocalPath);
	}

	function basepath(){
		$fdir = preg_replace('/\\\\/', '/', __DIR__);
		$fdir = preg_replace('/\/$/', '', $fdir);
		$fdir = $fdir.'/';

		$root_dir = $_SERVER['DOCUMENT_ROOT'];
		$root_prefix = '';
		$public_html_dir = '/home/'.get_current_user().'/public_html/';
		if(strrpos($fdir, $public_html_dir, -strlen($fdir)) !== false){
			$root_dir = $public_html_dir;
			$root_prefix = '/~'.get_current_user();
		}

		$rdir = preg_replace('/\\\\/', '/', $root_dir);
		$rdir = preg_replace('/\/$/', '', $rdir);

		return preg_replace('/^'.preg_replace('/\//', '\/', preg_quote($rdir)).'/', $root_prefix, $fdir);
	}

	define("LOCALPATH", preg_replace('/\\\\/', '/', __DIR__).'/');
	define("BASEPATH", basepath());
	define("APPPATH", BASEPATH.explode('/', substr($_SERVER['REQUEST_URI'], strlen(BASEPATH)))[0].'/');
?>
