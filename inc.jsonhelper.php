<?php
	function jsonhelper_exit(&$json, $htmlstatus, $htmlmessage, $jsonstatus = null, $jsonmessage = null){
		header("HTTP/1.1 {$htmlstatus} {$htmlmessage}");
		
		$json['status'] = ($jsonstatus === null)? $htmlstatus : $jsonstatus;
		$json['message'] = ($jsonmessage === null)? $htmlmessage : $jsonmessage;
		
		exit(json_encode($json));
	}
?>