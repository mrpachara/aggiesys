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

				$code = ($error['code'] <= 505)? $error['code'] : 500;
				$message = strtok($error['message'], "\n");
			}

			header("HTTP/1.1 {$code} {$message}");
		}

		header("Content-Type: application/json; charset=utf-8");

		exit(json_encode($json));
	}

	function json_search(&$json){
		if(empty($json['links'])){
			$json['links'] = array();
		} else{
			$json['links'] = (array)$json['links'];
		}

		$json['links'][] = array(
			  'rel' => 'search'
			, 'type' => 'search'
		);
	}

	function json_page(&$json, $page){
		if(empty($page)) return;

		if(empty($json['links'])){
			$json['links'] = array();
		} else{
			$json['links'] = (array)$json['links'];
		}

		$json['links'][] = array(
			  'rel' => 'page_current'
			, 'type' => 'state'
			, 'total' => $page['total']
			, 'state' => array(
				  'page' => $page['current']
			)
		);
		$json['links'][] = array(
			  'rel' => 'page_previous'
			, 'type' => 'state'
			, 'state' => (!empty($page['previous']))? array(
				  'page' => $page['previous']
			) : null
		);
		$json['links'][] = array(
			  'rel' => 'page_next'
			, 'type' => 'state'
			, 'state' => (!empty($page['next']))? array(
				  'page' => $page['next']
			) : null
		);
	}
?>
