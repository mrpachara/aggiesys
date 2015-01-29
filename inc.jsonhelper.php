<?php
	function json_exit(&$json){
		global $conf;

		if(!empty($json['errors'])){
			$code = 500;
			$message = "Internal Server Error";
			foreach($json['errors'] as &$error){
				if(!empty($error['exception']) && ($error['exception'] instanceof Exception)){
					if(empty($error['code'])) $error['code'] = $error['exception']->getCode();
					if(empty($error['message'])) $error['message'] = $error['exception']->getMessage();

					if($conf['debug'] == 0){
						unset($error['exception']);

						if($error['exception'] instanceof PDOException) $message = "Database Error!!!";
					};
				} else{
					if(empty($error['code'])) $error['code'] = $code;
					if(empty($error['message'])) $error['message'] = $message;
				}

				if($error['code'] <= 505) $code = $error['code'];
				$message = strtok($error['message'], "\n");
			}

			header("HTTP/1.1 {$code} {$message}");
		}

		header("Content-Type: application/json; charset=utf-8");

		exit(json_encode($json));
	}
?>
