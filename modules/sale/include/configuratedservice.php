<?php
	require_once "../generator/include/generator.service.php";
	require_once "../customer/include/configuratedservice.php";
	require_once "../vegetable/include/configuratedservice.php";
	require_once "service.php";

	$saleService = $entityService = new \app\SaleService("\\app\\GeneratorService", $customerService, $vegetableService);
?>
