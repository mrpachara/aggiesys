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
	);
?>
