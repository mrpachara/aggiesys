<?php
	$_fields = array(
		array(
			  'name' => "username"
			, 'width' => "25%"
			, 'required' => array(
				  'create' => true
			)
			, 'readonly' => array(
				  'update' => true
			)
		)
		,array(
			  'name' => "fullname"
			, 'width' => "25%"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "roles"
			, 'width' => "50%"
			, 'display' => array(
				  'create' => "checkboxlist.domain"
				, 'update' => "checkboxlist.domain"
			)
			, 'links' => array(
				  array(
					  'rel' => "domain"
					, 'type' => "get"
					, 'href' => BASEPATH."modules/role/list.php"
				)
			)
		)
		, array(
			  'name' => "password"
			, 'show' => array(
				  'create' => true
				, 'update' => true
			)
			, 'required' => array(
				  'create' => true
			)
		)
	);
?>
