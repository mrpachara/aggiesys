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
			, 'width' => "75%"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "items"
			, 'show' => array(
				  'create' => true
				, 'update' => true
				, 'self' => true
			)
			, 'display' => array(
				  'create' => "datagrid"
				, 'update' => "datagrid"
				, 'self' => "datagrid"
			)
			, 'fields' => array(
				  array(
					  'name' => "code"
					, 'required' => array(
						  'create' => true
						, 'update' => true
					)
				)
				, array(
					  'name' => "value"
					, 'required' => array(
						  'create' => true
						, 'update' => true
					)
				)
			)
		)
	);
?>
