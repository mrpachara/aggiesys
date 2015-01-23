<?php
	$tstmp_start = time();

	require_once "../../../global.inc.php";

	$_session->authozPage();

	if(empty($_SESSION['timestamp'])){
		$_SESSION
		['test'] = 'test';
	} else{
		unset($_SESSION['test']);
	}
	$_SESSION['timestamp'] = time();
	$pdo = new \sys\PDO();

	try{
		$stmt = $pdo->prepare('SELECT * FROM "user" WHERE "id" = :id;');
		$stmt->execute(array(
			':id' => $_session->getUser()['id']
		));
		$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
	} catch(PDOException $excp){
		$data = $excp->getMessage();
	}

	if(!empty($_GET['sleep'])) sleep($_GET['sleep']);

?>
<pre>Start Timestamp: <?php print_r($tstmp_start); ?></pre>
<a href="dbtest">DBTest</a>
<a href="../_session.php" target="_blank">Session</a>
<a href="login/logout">Logout</a>
<hr />

<h4>PATH:</h4>
<pre><?php echo LOCALPATH; ?></pre>
<pre><?php echo BASEPATH; ?></pre>
<pre><?php echo reflocation(__DIR__); ?></pre>
<hr />

<h4>Data:</h4>
<pre><?php print_r($data); ?></pre>
<hr />

<h4>Config:</h4>
<pre><?php print_r($conf); ?></pre>
<hr />

<h4>User:</h4>
<pre><?php print_r($_session->getUser()); ?></pre>
<hr />

<pre>Using Time: <?= (time() - $tstmp_start) ?></pre>
