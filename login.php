<?php
	require_once "global.inc.php";
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<meta charset="UTF-8" />
		<title><?= htmlspecialchars($conf['app']['name']) ?> Login</title>
	</head>
	<body id="layout-container" class="layout">
		<form method="post" action="login_submit.php">
			<div>
				<label for="usrename">Username:</label>
				<input type="text" id="username" name="username" />
			</div>
			<div>
				<label for="usrename">Password:</label>
				<input type="password" id="password" name="password" />
			</div>
			<div>
				<button type="submit" name="_action" value="LOGIN">Login</button>
			</div>
		</form>
<?php if(!empty($_tmpsess['errors'])): ?>
		<ul>
<?php 	foreach($_tmpsess['errors'] as $error): ?>
			<li><?= htmlspecialchars($error['message']) ?></li>
<?php 	endforeach; ?>
		</ul>
<?php endif; ?>
	</body>
</html>
