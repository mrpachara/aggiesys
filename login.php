<?php
	require_once "global.inc.php";
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" ng-app="Aggiesys">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<meta charset="UTF-8" />
		<title><?= htmlspecialchars($conf['app']['name']) ?> Login</title>

		<script src="js/lib/bower_components/angular/angular.js"></script>
		<script src="js/lib/bower_components/angular-aria/angular-aria.js"></script>
		<script src="js/lib/bower_components/angular-animate/angular-animate.js"></script>
		<script src="js/lib/bower_components/hammerjs/hammer.js"></script>
		<script src="js/lib/bower_components/angular-material/angular-material.js"></script>

		<script src="js/aggiesys.js"></script>

		<link rel="stylesheet" href="js/lib/bower_components/angular-material/angular-material.css" />
	</head>
	<body>
		<md-content class="md-padding">
			<form method="post" action="login_submit.php" ng-controller="LoginController">
				<div layout="column">
					<md-input-container flex>
						<label>Username</label>
						<input ng-modle="username" />
					</md-input-container>
					<md-input-container flex>
						<label for="usrename">Password:</label>
						<input type="password" id="password" name="password" />
					</md-input-container>
				</div>
				<div>
					<md-button type="submit" class="md-primary" name="_action" value="LOGIN">Login</md-button>
				</div>
			</form>
		</md-content>
<?php if(!empty($_tmpsess['errors'])): ?>
		<ul>
<?php 	foreach($_tmpsess['errors'] as $error): ?>
			<li><?= htmlspecialchars($error['message']) ?></li>
<?php 	endforeach; ?>
		</ul>
<?php endif; ?>
	</body>
</html>
