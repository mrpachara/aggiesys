var aggiesys = angular.module('Aggiesys', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate']);
window.app = aggiesys;

(function(window, document, $, angular){
	'use strict';

	aggiesys.config(function($routeProvider, $locationProvider){
		$routeProvider
			.when('/', {
				 redirectTo:'/login'
			})
			.when('/:module', {
				 templateUrl: function(params){
					console.log(params);
					return BASEPATH + 'modules/' + params['module'] + '/view/index.php';
				}
				,resolve: function(){
					console.log('called');
				}
			})
			.when('/:module/:operator*', {
				 templateUrl: function(params){
					return BASEPATH + 'modules/' + params['module'] + '/' + params['operator'] + '.php';
				}
			})
		;

		$locationProvider.html5Mode(true);
	});

	var requestAsURIEncode = function(data){
		var requestBodys = [];
		for(var key in data){
			requestBodys.push(key + '=' + encodeURIComponent(data[key]));
		}

		return requestBodys.join('&');
	};

	aggiesys.controller('LayoutController', function($scope, $mdSidenav){
		$scope.openSidenav = function(){
			$mdSidenav('left').open();
		}
	});

	aggiesys.controller('LoginController', function($scope, $http, $mdToast, $location){
		$scope.data = {
			 'username': ''
			,'password': ''
		};

		$scope.errors = [];

		$scope.submit = function(ev){
			ev.preventDefault();
			var $form = $(ev.delegateTarget);

			$http.post($form.attr('action'), $scope.data, {
				 'headers': {'Content-Type': $form.prop('enctype')}
				,'transformRequest': ($form.prop('enctype').split(';')[0].trim().toLowerCase() === 'application/x-www-form-urlencoded')? requestAsURIEncode : $http.defaults.transformResponse
				,'responseType': 'json'
			})
				.success(function(data){
					$scope.errors = [];

					$mdToast.show(
						$mdToast.simple()
							.content(data.links[0].href)
							//.position('top right')
					);

					$location.path(data.links[0].href);
				})
				.error(function(data){
					//$scope.errors = data.errors;
					$(data.errors).each(function(){
						$scope.errors.push(this);
					});

					$mdToast.show(
						$mdToast.simple()
							.content(data.errors[0].message)
							//.position('top right')
					);
				})
			;
		};
	});
})(this, this.document, this.jQuery, this.angular);
