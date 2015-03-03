<?php
	$_fields = array(
		array(
			 'name' => "id"
			, 'width' => "15em"
		)
		,array(
			 'name' => "expires"
			, 'width' => "15em"
			, 'expression' => array(
				  'display' => "toString() | datetime_locale"
			)
		)
		,array(
			 'name' => "username"
		)
	);
?>
