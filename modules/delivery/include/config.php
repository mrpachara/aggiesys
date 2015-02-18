<?php
	$_fields = array(
		array(
			  'name' => "code"
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
			  'name' => "date"
			, 'width' => "15em"
			, 'template' => array(
					  'create' => 'text.domain'
					, 'update' => 'text.domain'
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
		,array(
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
				  'create' => "template.domain"
				, 'update' => "template.domain"
				, 'self' => "template.domain"
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
				, array(
					  'rel' => 'template'
					, 'type' => 'get'
					, 'href' => BASEPATH."modules/delivery/template/farm.html"
				)
			)
		)
		,array(
			  'name' => "details"
			, 'show' => array(
				  'create' => true
				, 'update' => true
				, 'self' => true
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
					, 'width' => '3em'
					, 'template' => array(
						  'create' => 'text.domain'
						, 'update' => 'text.domain'
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
				, array(
					  'name' => "price"
					, 'width' => '3em'
					, 'template' => array(
						  'create' => 'text.domain'
						, 'update' => 'text.domain'
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
				  'create' => "datalist"
				, 'update' => "datalist"
				, 'self' => "datalist"
			)
		)
	);
?>
