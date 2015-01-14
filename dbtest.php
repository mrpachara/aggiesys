<?php
	$tstmp_start = time();
	echo "<pre>{$tstmp_start}</pre>";
	require_once "config.inc.php";
	require_once "inc.db.php";
	require_once "inc.sessions.php";

	echo "<pre>".time()."</pre>";
	$_session = new \sys\Sessions();
	if(empty($_SESSION['timestamp'])){
		$_SESSION['test'] = 'test';
	} else{
		unset($_SESSION['test']);
	}
	$_SESSION['timestamp'] = time();
	$pdo = new \sys\PDO();

	echo "<pre>".time()."</pre>";
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
		<pre>User: <?php var_dump($_session->getUser()); ?></pre>
		<pre>Time: <?= (time() - $tstmp_start) ?></pre>
	</body>
</html>
