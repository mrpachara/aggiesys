<?php
	$_fields = array(
		array(
			  'name' => "code"
			, 'width' => "10em"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "name"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "registration"
			, 'width' => "10em"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "code_typecarriage"
			, 'show' => array(
				  'create' => true
				, 'update' => true
			)
			, 'template' => array(
				  'create' => 'radiogroup.domain'
				, 'update' => 'radiogroup.domain'
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
			, 'links' => array(
				  array(
					  'rel' => 'domain'
					, 'type' => 'get'
					, 'href' => BASEPATH."modules/etc/items.php?code=TYPE_CARRIAGE"
				)
			)
		)
		,array(
			  'name' => "name_typecarriage"
			, 'width' => "10em"
			, 'show' => array(
				  'self' => true
				, 'list' => true
			)
		)
	);
?>
