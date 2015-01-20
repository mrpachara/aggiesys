<?php
	require_once "../config.inc.php";
?>
<md-toolbar class="md-primary">
	<h1 class="md-toolbar-tools">Login Form</h1>
</md-toolbar>
<md-content class="md-padding" ng-controller="LoginController">
	<form name="loginForm" method="post" action="<?= htmlspecialchars(BASEPATH) ?>pages/login_submit.php" ng-submit="submit($event)">
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
	<md-list>
		<md-item ng-repeat="error in errors">
			<md-item-content class="md-warn">
				<div class="md-tile-content">
					<p>{{error.message}}</p>
				</div>
			</md-item-content>
		</md-item>
	</md-list>
</md-content>
