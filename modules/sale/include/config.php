<?php
	$_fields = array(
		  array(
			  'name' => "code"
			, 'name_field' => 'รหัสใบขายพืชผล'
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
					, 'name_field' => 'วันที่ใบขายพืชผล'
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
			, 'name_field' => 'วันที่ใบขายพืชผล'
			, 'width' => "12em"
			, 'expression' => array(
				  'display' => "toString() | datetime_locale"
			)
			, 'template' => array(
				  '*' => null
			)
		)
		, array(
			  'name' => "customer"
			, 'name_field' => 'ลูกค้า'
			, 'required' => array(
				'*' => true
			)
			, 'fields' => array(
				  array(
					  'name' => 'name'
					, 'name_field' => 'ชื่อลูกค้า'
					, 'required' => array(
						  '*' => true
					)
				)
				, array(
					  'name' => 'address'
					, 'name_field' => 'ที่อยู่ลูกค้า'
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
					, 'href' => BASEPATH."modules/customer/list.php"
				)
			)
		)
		, array(
			  'name' => "registration"
			, 'name_field' => 'ทะเบียนรถ'
			, 'width' => '10em'
			, 'require' => array(
				  '*' => true
			)
			, 'template' => array(
				  '*' => 'text'
			)
		)
		, array(
			  'name' => "deliveries"
			, 'name_field' => 'ใบรับพืชผล'
			, 'template' => array(
				  'create' => "checkboxlist.domain"
				, 'replace' => "checkboxlist.domain"
			)
			, 'show' => array(
				  'create' => true
				, 'replace' => true
				, 'self' => true
			)
			, 'links' => array(
				  array(
					  'rel' => 'domain'
					, 'type' => 'get'
					, 'href' => BASEPATH."modules/delivery/list.php?term=unsold:"
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
						  array(
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
			, 'name_field' => 'ผู้ออกใบขายพืชผล'
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
