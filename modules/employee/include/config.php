<?php
	$_fields = array(
		array(
			  'name' => "code"
			, 'name_field' => 'รหัสทีมงาน'
			, 'width' => "10em"
			, 'readonly' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "fname"
			, 'name_field' => 'ชื่อ'
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "lname"
			, 'name_field' => 'นามสกุล'
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "tel"
			, 'name_field' => 'โทรศัพท์'
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address_line"
			, 'name_field' => 'ที่อยู่'
			, 'show' => array(
				  'self' => true
				, 'create' => true
				, 'replace' => true
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address_rd"
			, 'name_field' => 'ถนน'
			, 'show' => array(
				  'self' => true
				, 'create' => true
				, 'replace' => true
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address_t"
			, 'name_field' => 'ตำบล'
			, 'show' => array(
				  'self' => true
				, 'create' => true
				, 'replace' => true
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address_a"
			, 'name_field' => 'อำเภอ'
			, 'show' => array(
				  'self' => true
				, 'create' => true
				, 'replace' => true
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address_j"
			, 'name_field' => 'จังหวัด'
			, 'show' => array(
				  'self' => true
				, 'create' => true
				, 'replace' => true
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
		,array(
			  'name' => "address_zipcode"
			, 'name_field' => 'รหัสไปรษณีย์'
			, 'show' => array(
				  'self' => true
				, 'create' => true
				, 'replace' => true
			)
			, 'required' => array(
				  'create' => true
				, 'update' => true
			)
		)
	);
?>
