<?php
	error_reporting(E_ALL);
	ini_set('display_errors', 1);

	$pdo = new PDO('pgsql:host=localhost;dbname=mytest;user=ere;password=ere');
	$stmt = $pdo->prepare("SELECT * FROM mytest;");
	$stmt->execute();
	$data = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" data-ng-app="AutosMart" data-ng-init="contentPath='content/'">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<meta charset="UTF-8" />
		<title>DB Test</title>
	</head>
	<body>
		<pre><?php var_dump($data); ?></pre>
	</body>
</html>
