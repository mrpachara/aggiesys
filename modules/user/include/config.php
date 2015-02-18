<?php
	$_fields = array(
		array(
			  'name' => "username"
			, 'width' => "10em"
			, 'required' => array(
				  'create' => true
			)
			, 'readonly' => array(
				  'update' => true
			)
		)
		,array(
			  'name' => "fullname"
			, 'width' => "15em"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "roles"
			, 'template' => array(
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
