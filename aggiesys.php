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

		<script src="<?= BASEPATH ?>js/lib/bower_components/jquery/dist/jquery.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular/angular.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-aria/angular-aria.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-animate/angular-animate.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/hammerjs/hammer.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-route/angular-route.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-material/angular-material.js"></script>
		<script src="<?= BASEPATH ?>js/lib/bower_components/angular-messages/angular-messages.js"></script>
		<script src="<?= BASEPATH ?>js/lib/angular-icons-svg.js"></script>

		<script>
var BASEPATH = <?= json_encode(BASEPATH) ?>;
		</script>
		<script src="<?= BASEPATH ?>js/aggiesys.js"></script>

		<style>

html,
body {
	overflow: hidden;
}

#ly-header .md-toolbar-tools {
	width: auto !important;
}

#ly-header .md-toolbar-tools:last-child {
	margin-left: auto;
}

md-sidenav.md-locked-open {
	min-width: 15em;
	width: 15em;

	-webkit-box-shadow: none;
	box-shadow: none;
}

ng-view,
[ng-view] {
	padding: 1em;
}

ic-svg,
[ic-svg],
[data-ic-svg] {
	display: inline-block;
	padding: 0px;
	margin: 0px;

	width: 24px;
	height: 24px;

	flex: 0 0 auto;
}

ic-svg>svg,
[ic-svg]>svg,
[data-ic-svg] {
	width: 100%;
	height: 100%;
}

table.app-view-list {
	width: 100%;
	border-collapse: collapse;
}

table.app-view-list>*>tr {
	height: 3em;
	border-bottom: 1px solid gray;
}

table.app-view-list>thead>tr>th {
	text-align: left;
}

table.app-view-list .app-view-action-list {
	justify-content: space-around;
}

table.app-view-list .app-view-list-altheader{
	display: none;

	color: blue;
	font-weight: bold;

	width: 25%;
	text-align: right;

	padding-right: 1em;
}

table.app-view-list .app-view-list-altheader::after {
	content: ':';
}

table.app-view-list .app-view-list-value {
	display: inline-block;
}

form.app-view-self {
}
@media (max-width: 600px) {
	table.app-view-list>*>tr {
		padding-top: 1em;
		padding-bottom: 1em;
	}

	table.app-view-list>thead>tr>th:not(:last-child){
		display: none;
	}

	table.app-view-list>thead>tr>th:first-child{
		display: block;

		visibility: hidden;
	}

	table.app-view-list>tbody>tr>td:not(:last-child){
		display: flex;
	}

	table.app-view-list .app-view-list-altheader{
		display: inline-block;
	}
}
		</style>
	<body layout="row" ng-controller="LayoutController">
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
					<div>abacd</div>
					<div>abacd</div>
					<div>abacd</div>
					<div>abacd</div>
				</div>
			</md-content>
		</md-sidenav>
		<div flex layout="column">
			<!-- md-scroll-shrink -->
			<md-toolbar>
				<header id="ly-header" layout="row">
					<div class="md-toolbar-tools" hide-gt-md>
						<md-button ng-click="openSidenav()" aria-label="show side nav">
							<ic-svg ic-href="#ic_menu"></ic-svg>
						</md-button>
					</div>
					<h2 class="md-toolbar-tools">
						<span>xxx</span>
					</h2>
					<ul class="md-toolbar-tools">
						<li>abcd</li>
						<li>abcd</li>
						<li>abcd</li>
						<li>abcd</li>
						<li>abcd</li>
					</ul>
				</header>
			</md-toolbar>
<!--
<div layout="row" layout-align="left center" style="height: 0px; padding-left: 4em; align-items: center;">
	<md-button class="md-fab md-warn" aria-label="New document">
		<ic-svg ic-href="#ic_view_list_create"></ic-svg>
	</md-button>
</div>
-->
			<md-content layout="column" flex style="overflow-y: scroll;">
				<main ng-view flex></main>
			</md-content>
		</div>
	</body>
</html>
