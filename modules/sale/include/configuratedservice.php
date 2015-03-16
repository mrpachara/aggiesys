<?php
	require_once "../generator/include/configuratedservice.php";
	require_once "../customer/include/configuratedservice.php";
	require_once "../carriage/include/configuratedservice.php";
	require_once "../vegetable/include/configuratedservice.php";
	require_once "service.php";

	$saleService = $entityService = new \app\SaleService("\\app\\GeneratorService", $customerService, $carriageService, $vegetableService);
?>
