<?php
	$_fields = array(
		array(
			  'name' => "code"
			, 'name_field' => 'รหัสพืชผล'
			, 'width' => "10em"
			, 'readonly' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "name"
			, 'name_field' => 'ชื่อพืชผล'
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "price_buy"
			, 'name_field' => 'ราคาซื้อ'
			, 'width' => "10em"
			, 'required' => array(
				  '*' => true
			)
			, 'template' => array(
				  '*' => 'text.domain'
			)
			, 'links' => array(
				  array(
					  'rel' => 'domain'
					, 'accept' => 'number'
				)
			)
		)
		,array(
			  'name' => "price_sell"
			, 'name_field' => 'ราคาขาย'
			, 'width' => "10em"
			, 'required' => array(
				  '*' => true
			)
			, 'template' => array(
				  '*' => 'text.domain'
			)
			, 'links' => array(
				  array(
					  'rel' => 'domain'
					, 'accept' => 'number'
				)
			)
		)
	);
?>
