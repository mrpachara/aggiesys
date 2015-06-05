<?php
	require_once "../../BASEPATH.php";

	$json = array(
		 'content-type' => "image/svg+xml; charset=utf-8"
		,'links' => array()
	);

	$abspath = reflocation(__DIR__).'/';

	foreach (glob("svg/*.svg") as $filename) {
		$json['links'][] = $abspath.$filename;
	}

	header("Content-Type: application/json; charset=utf-8");
	echo json_encode($json);
?>
