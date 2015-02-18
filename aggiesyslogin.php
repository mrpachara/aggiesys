<?php
	require_once "global.inc.php";
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

		<script src="<?= BASEPATH ?>js/aggiesys.js"></script>

	<body layout="row">
		<!-- md-whiteframe-z2 -->
		<md-sidenav md-swipe-left="$mdSidenav('left').close()" md-component-id="left" md-is-locked-open="$media('gt-md')" class="md-sidenav-left md-whiteframe-z2">
			<md-toolbar>
				<h1 class="md-toolbar-tools">
					<span><?= htmlspecialchars($conf['app']['name']) ?></span>
				</h1>
			</md-toolbar>
			<md-content flex class="md-padding" layout="column">
				<div ng-click="$mdSidenav('left').close()">
					<div>
						<a href="delivery/list">Delivery</a>
					</div>
					<div>
						<a href="vegetable/list">Vegetable</a>
					</div>
					<div>
						<a href="farm/list">Farm</a>
					</div>
					<div>
						<a href="customer/list">Customer</a>
					</div>
					<div>
						<a href="carriage/list">Carriage</a>
					</div>
					<div>
						<a href="user/list">User</a>
					</div>
					<div>
						<a href="session/list">Session</a>
					</div>
					<div>
						<a href="etc/list">Etc</a>
					</div>
				</div>
			</md-content>
		</md-sidenav>
		<div flex layout="column">
			<!-- md-scroll-shrink -->
			<md-toolbar>
				<header id="ly-header" class="md-toolbar-tools" flex>
					<div layout-align="start center" layout="row">
						<md-button id="app-cmd-view-cmd" ng-click="$mdSidenav('left').open()" hide-gt-md aria-label="show side nav">
							<ic-svg ic-href="#ic_menu"></ic-svg>
						</md-button>
					</div>
					<h2 id="app-cp-title" ng-hide="appIsHasViewSearch && appIsActiveViewSearch">
						<span>{{appViewTitle}}</span>
					</h2>
					<div ng-class="{'app-ly-opt-flex': appIsHasViewSearch && appIsActiveViewSearch}" layout="row">
						<form id="app-cp-view-search" ng-show="appIsHasViewSearch" ng-class="{'app-st-active': appIsHasViewSearch && appIsActiveViewSearch, 'app-st-padding': appViewSearchText != appViewSearchTerm}" ng-submit="appSubmitViewSearch($event)" layout="row">
							<md-button id="app-cmd-view-search" ng-click="appActiveViewSearch($event)" aria-label="search bar">
								<ic-svg ic-href="#ic_search"></ic-svg>
							</md-button>
							<md-input-container class="app-cl-search-box" flex>
								<input type="search" ng-blur="appDeactiveViewSearch()" name="term" ng-model="appViewSearchText" placeholder="{{appViewSearchTerm}}" />
							</md-input-container>
							<md-button id="app-cmd-view-search-reset" ng-click="appActiveViewSearch($event, '')" aria-label="reset search bar">
								<ic-svg ic-href="#ic_clear"></ic-svg>
							</md-button>
						</form>
						<md-button ng-click="appTestProgressLoad()" aria-label="more menu">
							<ic-svg ic-href="#ic_more_vert"></ic-svg>
						</md-button>
					</div>
				</header>
				<md-progress-linear id="app-cp-progress-loading" md-mode="indeterminate" ng-class="{'app-st-active': loading > 0}" class="md-accent"></md-progress-linear>
			</md-toolbar>
			<md-content id="app-ly-container-content" layout="column" flex>
				<main class="app-cp-content" ng-view flex></main>
			</md-content>
		</div>
	</body>
</html>
