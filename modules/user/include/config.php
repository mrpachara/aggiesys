<?php
	$_fields = array(
		array(
			 'name' => "username"
			,'required' => true
			,'readonly' => true
		)
		,array(
			 'name' => "fullname"
			,'required' => true
		)
		,array(
			 'name' => "roles"
			,'display' => array(
				 'update' => "checkbox.domain"
			)
			,'links' => array(
				array(
					'rel' => "domain"
					,'type' => "get"
					,'href' => BASEPATH."modules/role/list.php"
				)
			)
		)
	);
?>
