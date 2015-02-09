<?php
	$_fields = array(
		array(
			  'name' => "code"
			, 'width' => "25%"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "name"
			, 'width' => "25%"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address"
			, 'width' => "50%"
			, 'display' => array(
				  'create' => 'textarea'
				, 'update' => 'textarea'
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
	);
?>
