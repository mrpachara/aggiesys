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
			  'name' => "items"
			, 'show' => array(
				  'create' => true
				, 'update' => true
				, 'self' => true
			)
			, 'fields' => array(
				  array(
					  'name' => "code"
					, 'width' => '10em'
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
			, 'template' => array(
				  'create' => "datalist"
				, 'update' => "datalist"
				, 'self' => "datalist"
			)
		)
	);
?>
