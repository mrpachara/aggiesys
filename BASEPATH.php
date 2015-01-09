<?php
	/*
		IMPOTENT: THIS FILE MUST PUT ON ROOT DIRECTORY OF APPLICATION.
	*/
	function localpath($file){
		return preg_replace('/^'.preg_replace('/\//', '\/', preg_quote(BASEPATH)).'/', '', $file);
	}
	
	function basepath(){
		$fdir = preg_replace('/\\\\/', '/', __DIR__);
		$fdir = preg_replace('/\/$/', '', $fdir);
		$fdir = $fdir.'/';
		
		$rdir = preg_replace('/\\\\/', '/', $_SERVER['DOCUMENT_ROOT']);
		$rdir = preg_replace('/\/$/', '', $rdir);
		
		return preg_replace('/^'.preg_replace('/\//', '\/', preg_quote($rdir)).'/', '', $fdir);
	}
	
	define("BASEPATH", basepath());
?>