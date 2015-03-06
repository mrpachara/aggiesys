<?php
	$_fields = array(
		  array(
			  'name' => "code"
			, 'name_field' => 'รหัสใบรับพืชผล'
			, 'width' => "10em"
			, 'readonly' => array(
				  '*' => true
			)
			, 'required' => array(
				  '*' => true
			)
			, 'template' => array(
				  '*' => 'headcodedate'
			)
			, 'fields' => array(
				  array(
					  'name' => "date"
					, 'name_field' => 'วันที่ใบรับพืชผล'
					, 'template' => array(
						  '*' => 'text.domain'
					)
					, 'required' => array(
						  '*' => true
					)
					, 'links' => array(
						  array(
							  'rel' => 'domain'
							, 'accept' => 'datetime-local'
						)
					)
				)
			)
		)
		, array(
			  'name' => "date"
			, 'name_field' => 'วันที่ใบรับพืชผล'
			, 'width' => "12em"
			, 'expression' => array(
				  'display' => "toString() | datetime_locale"
			)
			, 'template' => array(
				  '*' => null
			)
		)
		, array(
			  'name' => "farm"
			, 'name_field' => 'ลูกสวน'
			, 'required' => array(
				'*' => true
			)
			, 'fields' => array(
				  array(
					  'name' => 'name'
					, 'name_field' => 'ชื่อลูกสวน'
					, 'required' => array(
						  '*' => true
					)
				)
				, array(
					  'name' => 'address'
					, 'name_field' => 'ที่อยู่ลูกสวน'
					, 'template' => array(
						  '*' => 'textarea'
					)
				)
			)
			, 'template' => array(
				  '*' => "headowner.domain"
			)
			, 'expression' => array(
				  'label' => "code"
				, 'display' => "(id)? code + '-' + name : ''"
			)
			, 'links' => array(
				  array(
					  'rel' => 'domain'
					, 'type' => 'get'
					, 'href' => BASEPATH."modules/farm/list.php"
				)
			)
		)
		, array(
			  'name' => "details"
			, 'name_field' => 'รายการพืชผล'
			, 'show' => array(
				  'self' => true
				, 'create' => true
				, 'replace' => true
			)
			, 'fields' => array(
				  array(
					  'name' => "vegetable"
					, 'name_field' => 'พืชผล'
					, 'template' => array(
						  'create' => "autocomplete.domain"
						, 'replace' => "autocomplete.domain"
					)
					, 'required' => array(
						  '*' => true
					)
					, 'expression' => array(
						  'label' => "(id)? code + '-' + name : ''"
					)
					, 'links' => array(
						  array(
							  'rel' => 'domain'
							, 'type' => 'get'
							, 'href' => BASEPATH."modules/vegetable/list.php"
						)
					)
				)
				, array(
					  'name' => "qty"
					, 'name_field' => 'จำนวน'
					, 'width' => '10em'
					, 'template' => array(
						  '*' => 'text.domain'
					)
					, 'required' => array(
						  '*' => true
					)
					, 'links' => array(
						  array(
							  'rel' => 'domain'
							, 'accept' => 'number'
						)
					)
				)
				, array(
					  'name' => "price"
					, 'name_field' => 'ราคา'
					, 'width' => '10em'
					, 'template' => array(
						  '*' => 'text.domain'
					)
					, 'required' => array(
						  'create' => true
						, 'replace' => true
					)
					, 'expression' => array(
						  'calculate' => "vegetable.price_buy * qty"
					)
					, 'links' => array(
						  array(
							  'rel' => 'domain'
							, 'accept' => 'number'
						)
					)
					, 'summary' => array(
						  'sum' => array(
							  'expression' => "price"
							, 'text' => 'ราคารวม'
							, 'classes' => array('input-dynamic-cl-number')
						)
					)
				)
			)
			, 'template' => array(
				  '*' => 'datalist'
			)
		)
		, array(
			  'name' => "creator"
			, 'name_field' => 'ผู้ออกใบรับพืชผล'
			, 'width' => "10em"
			, 'readonly' => array(
				  '*' => true
			)
			, 'expression' => array(
				  'display' => "fullname"
				, 'label' => "username"
			)
			, 'template' => array(
					  '*' => null
					, 'self' => 'text'
			)
		)
	);
?>
