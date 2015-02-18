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
			, 'width' => "15em"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address"
			, 'template' => array(
				  'create' => 'textarea'
				, 'update' => 'textarea'
				, 'self' => 'textarea'
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
	);
?>
