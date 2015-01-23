var aggiesys = angular.module('Aggiesys', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate', 'icSvg']);
window.app = aggiesys;

(function($, angular){
	'use strict';

	var modulesResover = function(){

	};

	aggiesys.config(function($routeProvider, $locationProvider, $icSvgProvider, $mdToastProvider){
		$routeProvider
			.when('/', {
				 redirectTo:'/login'
			})
			.when('/login', {
				'templateUrl': BASEPATH + 'modules/login/view/index.php'
			})
			.when('/:module', {
				 'templateUrl': BASEPATH + 'views/list.html'
				,'controller': 'ListEntityController'
				,'resolve': {
					'model': function($route, $http, $mdToast){
						return $http.get(BASEPATH + '/modules/' + $route.current.params.module + '/list.php')
							.then(function(req){
								return req.data;
							}, function(req){
								$mdToast.show(
									$mdToast.simple()
										.content(req.statusText)
								);
							})
						;
					}
				}
			})
			/*
			.when('/:module', {
				 templateUrl: function(params){
					//console.log(params);
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
			*/
		;

		$locationProvider.html5Mode(true);

		$icSvgProvider
			.url(BASEPATH + 'icons/material-design-icons/links.php')
			.svgTransform(function(svg){
				var svgFragment = svg.createDocumentFragment();

				angular.forEach(svg.documentElement.childNodes, function(node){
					if((node.nodeType === svg.ELEMENT_NODE) && (node.nodeName.toLowerCase() === 'svg')){
						var symbolElem = svg.createElementNS('http://www.w3.org/2000/svg', 'symbol');
						var idSplit = node.getAttribute('id').split('_');
						idSplit.pop();
						symbolElem.setAttribute('id', idSplit.join('_'));
						symbolElem.setAttribute('viewBox', node.getAttribute('viewBox'));
						symbolElem.setAttribute('preserveAspectRatio', 'xMidYMid meet');

						angular.element(symbolElem).append(node.childNodes);

						node = symbolElem;
					}

					svgFragment.appendChild(node);
				});

				var newSvgElem = svg.createElementNS('http://www.w3.org/2000/svg', 'svg');
				newSvgElem.appendChild(svgFragment);
				svg.replaceChild(newSvgElem, svg.documentElement);

				return svg;
			})
		;

		console.log($mdToastProvider.setDefaults);
		/*
		$mdToastProvider
			.setDefaults({
				'options': function(){
					return {'capsule': true};
				}
			})
		;
		*/
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

	/* GLOBAL Controller */
	app.controller('ListEntityController', function($scope, $http, $location, model){
		$scope.model = model;
		$scope.self = function(id){
			$location.path(model.selfUrl + ((typeof id != 'undefined')? '/' + id : ''));
		};

		$scope.remove = function(id){
			$location.path(model.removeUrl + '/' + id);
		}
	});
})(this.jQuery, this.angular);
