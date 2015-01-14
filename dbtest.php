<?php
	require_once "config.inc.php";
	require_once "inc.db.php";
	require_once "inc.sessions.php";

	$_session = new \sys\Sessions();
	$_SESSION['timestamp'] = time();
	$pdo = new \sys\PDO();

	try{
		$stmt = $pdo->prepare('SELECT * FROM "user" WHERE "id" = :id;');
		$stmt->execute(array(
			':id' => 1
		));
		$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
	} catch(PDOException $excp){
		$data = $excp->getMessage();
	}

	if(!empty($_GET['sleep'])) sleep($_GET['sleep']);
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
		<pre><?php var_dump($_SESSION); ?></pre>
	</body>
</html>
