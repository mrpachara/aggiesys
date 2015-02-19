<?php
	$_fields = array(
		  array(
			  'name' => "code"
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
			, 'width' => "15em"
			, 'template' => array(
					  '*' => null
			)
		)
		, array(
			  'name' => "farm"
			, 'fields' => array(
				  array(
					  'name' => 'name'
					, 'required' => array(
						  '*' => true
					)
				)
				, array(
					  'name' => 'address'
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
			, 'show' => array(
				  'self' => true
				, 'create' => true
				, 'update' => true
			)
			, 'fields' => array(
				  array(
					  'name' => "vegetable"
					, 'template' => array(
						  'create' => "select.domain"
						, 'update' => "select.domain"
					)
					, 'required' => array(
						  '*' => true
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
					, 'width' => '10em'
					, 'template' => array(
						  '*' => 'text.domain'
					)
					, 'required' => array(
						  'create' => true
						, 'update' => true
					)
					, 'links' => array(
						  array(
							  'rel' => 'domain'
							, 'accept' => 'number'
						)
					)
				)
			)
			, 'template' => array(
				  '*' => 'datalist'
			)
		)
	);
?>
