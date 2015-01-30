<?php
	require_once "global.inc.php";
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" ng-app="Aggiesys" layout="column">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<meta charset="UTF-8" />
		<title><?= htmlspecialchars($conf['app']['name']) ?> Application</title>

		<base href="<?= htmlspecialchars(APPPATH) ?>" />

		<link rel="stylesheet" href="<?= BASEPATH ?>js/lib/bower_components/angular-material/angular-material.css" />
		<link rel="stylesheet" href="<?= BASEPATH ?>css/aggiesys.css" />

		<script src="<?= BASEPATH ?>js/lib/bower_components/jquery/dist/jquery.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular/angular.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-aria/angular-aria.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-animate/angular-animate.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-route/angular-route.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/hammerjs/hammer.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-material/angular-material.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-messages/angular-messages.js"></script>
		<script src="<?= BASEPATH ?>js/lib/angular-icons-svg.js"></script>

		<script>
var BASEPATH = <?= json_encode(BASEPATH) ?>;
		</script>
		<script src="<?= BASEPATH ?>js/aggiesys.js"></script>

	<body layout="row">
		<!-- md-whiteframe-z2 -->
		<md-sidenav class="md-sidenav-left md-whiteframe-z2" md-component-id="left" md-is-locked-open="$media('gt-md')">
			<md-toolbar>
				<h1 class="md-toolbar-tools">
					<span><?= htmlspecialchars($conf['app']['name']) ?></span>
				</h1>
			</md-toolbar>
			<md-content flex class="md-padding" layout="column">
				<div>
					<div>abacd</div>
					<div>abacd</div>
				</div>
			</md-content>
		</md-sidenav>
		<div flex layout="column">
			<!-- md-scroll-shrink -->
			<md-toolbar>
				<header id="ly-header" class="md-toolbar-tools" flex>
					<div layout-align="left center" layout="row">
						<md-button id="app-cmd-view-cmd" ng-click="$mdSidenav('left').open()" hide-gt-md aria-label="show side nav">
							<ic-svg ic-href="#ic_menu"></ic-svg>
						</md-button>
					</div>
					<h2 id="app-cp-title" ng-hide="isActiveViewSearch" layout="row">
						<span>{{isActiveViewSearch}}</span>
					</h2>
					<div ng-class="{'app-ly-opt-flex': isActiveViewSearch}" layout="row">
						<form id="app-cp-view-search" ng-class="{'app-st-active': isActiveViewSearch}" ng-animate="'app-st-active'" ng-submit="submitViewSearch($event)" layout="row">
							<md-button id="app-cmd-view-search" ng-click="activeViewSearch($event)" aria-label="search bar">
								<ic-svg ic-href="#ic_search"></ic-svg>
							</md-button>
							<md-input-container class="app-cl-search-box" flex style="padding-bottom: 0px;">
								<input type="text" name="term" required="true" style="border-color: rgba(0,0,0,0.12); border-width: 0 0 1px 0;" />
							</md-input-container>
						</form>
						<md-button ng-click="testProgressLoad()" aria-label="more menu">
							<ic-svg ic-href="#ic_more_vert"></ic-svg>
						</md-button>
					</div>
				</header>
				<md-progress-linear id="app-cp-progress-loading" md-mode="indeterminate" ng-class="{'app-st-active': loading > 0}" class="md-accent"></md-progress-linear>
			</md-toolbar>
			<md-content id="app-ly-container-content" layout="column" flex style="overflow-y: scroll;">
				<main id="app-cp-content" ng-view flex></main>
			</md-content>
		</div>
	</body>
</html>
