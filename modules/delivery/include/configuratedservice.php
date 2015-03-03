<?php
	require_once "../generator/include/generator.service.php";
	require_once "../farm/include/configuratedservice.php";
	require_once "../vegetable/include/configuratedservice.php";
	require_once "service.php";

	$deliveryService = $entityService = new \app\DeliveryService("\\app\\GeneratorService", $farmService, $vegetableService);
?>
