(function(angular){
	'use strict';

	var aggiesys = angular.module('Aggiesys', ['ngMaterial']);

	aggiesys.controller('LoginController', function($scope){
		$scope = {
			'username': '',
			'password': ''
		};
	});
})(window.angular);
