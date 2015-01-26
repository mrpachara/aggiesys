var aggiesys = angular.module('Aggiesys', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate', 'icSvg']);
window.app = aggiesys;

(function($, angular){
	'use strict';

	var modulesResover = function(){

	};

	var modelPromise = function($q, $route, $http, $mdToast){
		var defer = $q.defer();

		var url = BASEPATH + 'modules/' + $route.current.params.module + '/' + $route.current.params.operation + '.php';

		if(typeof $route.current.params.id != 'undefined'){
			url = url + '?id=' + encodeURIComponent($route.current.params.id);
		}

		$http.get(url)
			.then(function(response){
				defer.resolve(response.data);
			}, function(response){
				$mdToast.show(
					$mdToast.simple()
						.content(response.statusText)
				);

				defer.reject(response.data, response.statusText);
			})
		;

		return defer.promise;
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
				 'redirectTo': function(params){
					return '/' + params['module'] + '/list'
				}
			})
			.when('/:module/:operation/:id?', {
				 'templateUrl': function(params){
					return BASEPATH + 'views/' + params.operation + '.html'
				}
				,'controller': 'AppViewController'
				,'resolve': {
					'model': function($q, $route, $http, $mdToast){
						return modelPromise($q, $route, $http, $mdToast);
					}
				}
			})
			.when('/:module/xxx', {
				 'templateUrl': function(params){
					return BASEPATH + 'views/list.html'
				}
				,'controller': 'ListEntityController'
				,'resolve': {
					'model': function($q, $route, $http, $mdToast){
						return modelPromise($q, $http, $mdToast, $route.current.params.module, 'list');
					}
				}
			})
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
	});

	var requestAsUriEncode = function(data){
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
				,'transformRequest': ($form.prop('enctype').split(';')[0].trim().toLowerCase() === 'application/x-www-form-urlencoded')? requestAsUriEncode : $http.defaults.transformResponse
				,'responseType': 'json'
			})
				.success(function(data){
					$scope.errors = [];

					angular.forEach(data.links, function(link){
						if((link.rel === 'main') && (link.type === 'redirect')){
							$location.path(link.href);

							$mdToast.show(
								$mdToast.simple()
									.content('redirect to ' + link.rel)
									//.position('top right')
							);
						}
					});

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
	app.controller('AppViewController', function($scope, $http, $location, $route, $mdToast, model){
		//console.log(model);
		$scope.model = model;

		$scope.execute = function(link){
			if(link.type === 'view'){
				$location.path(link.href);
			} else{
				$http[link.type](link.href, ($.inArray(link.type, ['post']))? {
					 'data': $scope.model
				} : {})
					.then(function(response){
						$mdToast.show(
							$mdToast.simple()
								.content(response.data['message'])
						);

						$route.reload();
					}, function(response){
						$mdToast.show(
							$mdToast.simple()
								.content(response.statusText)
						);
					})
				;
			}
		};

		$scope.showModel = function(){
			console.log($scope.model);
		};
	});

	app.controller('AppViewCheckboxListController', function($scope, $attrs, $http){
		$scope.items = [];
		$scope.isChecked = {};

		var url = null;
		angular.forEach($scope.$eval($attrs.ngLinks), function(link){
			if(link.rel == 'domain') url = link.href;
		});

		$http.get(url)
			.then(function(response){
				angular.forEach(response.data.items, function(item){
					$scope.items.push(item.data);

					var binded = $scope.$eval($attrs.ngModel);
					angular.forEach($scope.items, function(value){
						$scope.isChecked[value] = (binded.indexOf(value) > -1);
					});
				});

				$scope.$watchCollection('isChecked', function(values){
					var binded = $scope.$eval($attrs.ngModel);
					binded.splice(0, binded.length);

					angular.forEach(values, function(value, key){
						if(value) binded.push(key);
					});
				});
			}, function(response){
				$mdToast.show(
					$mdToast.simple()
						.content(response.statusText)
				);

				defer.reject(response.data, response.statusText);
			})
		;
	});
})(this.jQuery, this.angular);
