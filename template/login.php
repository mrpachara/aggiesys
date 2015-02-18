<?php
	if(!defined("BASEPATH")){
		header("HTTP/1.1 404 Not Found");
		exit;
	}
?>
<!DOCTYPE html>
<html lang="th" xml:lang="th" xmlns="http://www.w3.org/1999/xhtml" ng-app="Aggiesys" layout="column">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<meta charset="UTF-8" />
		<meta http-equiv="Content-Language" content="en_US, th_TH" />
		<title><?= htmlspecialchars($conf['app']['name']) ?> Application</title>

		<base href="<?= htmlspecialchars(APPPATH) ?>" />

		<link rel="stylesheet" href="<?= BASEPATH ?>js/lib/bower_components/angular-material/angular-material.css" />
		<link rel="stylesheet" href="<?= BASEPATH ?>css/aggiesys.css" />

		<script>
var BASEPATH = <?= json_encode(BASEPATH) ?>;
		</script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/jquery/dist/jquery.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular/angular.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-aria/angular-aria.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-animate/angular-animate.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-route/angular-route.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-material/angular-material.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-messages/angular-messages.js"></script>
		<script src="<?= BASEPATH ?>js/lib/angular-icons-svg.js"></script>
		<script src="<?= BASEPATH ?>js/lib/angular-input-dynamic.js"></script>

		<script src="<?= BASEPATH ?>js/login.js"></script>
	</head>
	<body ng-view layout="row" layout-align="center center">
		<md-content>
			<md-toolbar class="md-primary">
				<h1 class="md-toolbar-tools" layout-align="center center">Login Form</h1>
				<md-progress-linear id="app-cp-progress-loading" md-mode="indeterminate" ng-class="{'app-st-active': loading > 0}" class="md-accent"></md-progress-linear>
			</md-toolbar>
			<md-content class="md-padding" ng-controller="LoginController">
				<form name="loginForm" method="post" action="<?= htmlspecialchars(BASEPATH) ?>modules/login/login.php" ng-submit="submit($event)">
					<div layout="column">
						<md-input-container flex>
							<label>Username</label>
							<input type="text" name="username" required autofocus ng-model="data.username" />
							<div ng-messages="loginForm.username.$error">
								<div ng-message="required">This is required.</div>
							</div>
							</md-input-container>
						<md-input-container flex>
							<label>Password</label>
							<input type="password" name="password" required ng-model="data.password" />
							<div ng-messages="loginForm.password.$error">
								<div ng-message="required">This is required.</div>
							</div>
						</md-input-container>
						<div layout layout-align="center center">
							<md-button type="submit" class="md-primary" name="_action" value="LOGIN" style="padding: 0.50em 1.00em;">Login</md-button>
						</div>
					</div>
				</form>
			</md-content>
		</md-content>
	</body>
</html>
