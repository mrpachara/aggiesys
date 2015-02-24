<?php
	$_fields = array(
		array(
			  'name' => "code"
			, 'name_field' => "รหัสลูกสวน"
			, 'width' => "10em"
			, 'readonly' => array(
				  '*' => true
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "name"
			, 'name_field' => "ชื่อลูกสวน"
			, 'width' => "15em"
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address"
			, 'name_field' => "ที่อยู่ลูกสวน"
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
