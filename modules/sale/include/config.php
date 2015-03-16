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
				  'display' => "toString() | datetime_app"
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
			  'name' => "carriage"
			, 'name_field' => 'รถขนส่ง'
			, 'width' => '10em'
			, 'require' => array(
				  '*' => true
			)
			, 'template' => array(
				  '*' => 'autocomplete.domain'
			)
			, 'expression' => array(
				  'label' => "(id)? registration + ' [' + code + '-' + name + ']' : ''"
				, 'display' => "(id)? registration : ''"
			)
			, 'links' => array(
				  array(
					  'rel' => 'domain'
					, 'type' => 'get'
					, 'href' => BASEPATH."modules/carriage/list.php"
				)
			)
		)
		, array(
			  'name' => "deliveries"
			, 'name_field' => 'ใบรับพืชผล'
			, 'template' => array(
				  'create' => "checkboxdoclist.domain"
				, 'replace' => "checkboxdoclist.domain"
				, 'self' => "doclist.deliveries-list"
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
					, 'transform' => array(
						  'details' => 'details-transform'
					)
				)
				, array(
					  'rel' => 'deliveries-list'
					, 'type' => 'get'
					, 'href' => BASEPATH."modules/delivery/list.php?term=id:"
				)
				, array(
					  'rel' => 'details-transform'
					, 'type' => 'post'
					, 'href' => BASEPATH."modules/sale/details.php"
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
						  'label' => "(id)? code + '-' + name + ' [' + (price_sell | currency:'\u0e3f':2) + ']' : ''"
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
							, 'min' => 0.01
							, 'fixed' => 2
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
						  'calculate' => "vegetable.price_sell * qty"
					)
					, 'links' => array(
						  array(
							  'rel' => 'domain'
							, 'accept' => 'number'
							, 'min' => 0
							, 'fixed' => 2
						)
					)
					, 'summary' => array(
						  array(
							  'expression' => "price"
							, 'text' => 'ราคารวม'
							, 'classes' => array('input-dynamic-cl-number')
							, 'fixed' => 2
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
