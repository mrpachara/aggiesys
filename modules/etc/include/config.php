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
				  'create' => "specific.input"
				, 'update' => "specific.input"
				, 'self' => "specific.view"
			)
			, 'links' => array(
				  array(
					  'rel' => 'input'
					, 'href' => BASEPATH."modules/etc/view/input.html"
				)
			)
		)
	);
?>
