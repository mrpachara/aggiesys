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

	var requestAsUriEncode = function(data){
		var requestBodies = [];

		var deepEncodeURIComponent = function(keyConverter, data){
			if(angular.isArray(data)){
				angular.forEach(data, function(value){
					deepEncodeURIComponent(function(){
						var index = 0;

						return keyConverter() + '[' + (index++) + ']';
					}, value);
				});
			} else if(angular.isObject(data)){
				angular.forEach(data, function(value, key){
					deepEncodeURIComponent(function(){
						return keyConverter() + '[' + key + ']';
					}, value);
				});
			} else{
				requestBodies.push(keyConverter() + '=' + encodeURIComponent(data));
			}
		}

		deepEncodeURIComponent(function(){
			return '';
		}, data);

		return requestBodies.join('&');
	};

	aggiesys.config(function($routeProvider, $locationProvider, $httpProvider, $icSvgProvider, $mdToastProvider){
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

		$httpProvider.interceptors.push(function($q){
			return {
				 'request': function(config){
					angular.forEach(config.headers, function(value, header){
						if(
							   (header.toLowerCase() === 'content-type')
							&& (value.split(';')[0].trim().toLowerCase() === 'application/x-www-form-urlencoded')
						){
							config.transformRequest = requestAsUriEncode;
						}
					});

					return config;
				}
			};
		});

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

	aggiesys.controller('LayoutController', function($scope, $mdSidenav){
		$scope.openSidenav = function(){
			$mdSidenav('left').open();
		}
	});

	aggiesys.controller('LoginController', function($scope, $http, $mdToast, $location){
		$scope.data = {
			 'username': ''
			,'password': ''
			,'test1': ['123', '456']
			,'test2': [
				 {
					 'a': 1
					,'b': 2
				}
				,{
					 'c': 3
					,'d':4
				}
			]
			,'test3': {
				 'abc': 321
				,'efg': 654
			}
			,'test4': {
				 'i': ['aa', 'bb']
				,'j': {
					 'x1': 'x'
					,'x2': 'xx'
					,'x3': 'xxx'
				}
				,'k': [
					 {
						 'y1': 'y'
						,'y2': 'yy'
						,'y3': 'yyy'
					}
					,{
						 'z1': 'z'
						,'z2': 'zz'
						,'z3': 'zzz'
					}
				]
			}
		};

		$scope.errors = [];

		$scope.submit = function(ev){
			ev.preventDefault();
			var $form = $(ev.delegateTarget);

			$http.post($form.attr('action'), $scope.data, {
				 'headers': {'Content-Type': $form.prop('enctype')}
				//,'transformRequest': ($form.prop('enctype').split(';')[0].trim().toLowerCase() === 'application/x-www-form-urlencoded')? requestAsUriEncode : $http.defaults.transformResponse
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
	app.controller('AppViewController', function($scope, $q, $http, $location, $route, $window, $mdToast, $mdDialog, model){
		//console.log(model);
		$scope.model = angular.copy(model);
		$scope.mode = (typeof model.mode != 'undefined')? model.mode : null;

		$scope.execute = function(link){
			if(link.type === 'submit'){
				if(typeof $scope.model.data != 'undefined') $scope.model.data = angular.copy(model.data);

				$scope.mode = link.rel;
			} else if(link.type === 'view'){
				$location.path(link.href);
			} else{
				var promise = $q.defer().resolve();

				if(typeof link.confirm != 'undefined'){
					var confirm = $mdDialog.confirm()
						.title(link.confirm.title)
						.content(link.confirm.content)
						.ariaLabel('comfirm ' + link.rel)
						.ok('OK')
						.cancel('Cancel')
					;

					promise = $mdDialog.show(confirm);
				}

				promise.then(function(){
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
				});
			}
		};

		var submitLink = null;
		$scope.setLink = function(link){
			submitLink = link;
		}

		$scope.submit = function(ev){
			ev.preventDefault();

			var link = submitLink;
			submitLink = null;

			var $form = $(ev.delegateTarget);

			$http.post(link.href, $scope.model.data, {
				 'headers': {'Content-Type': $form.prop('enctype')}
				,'transformRequest': ($form.prop('enctype').split(';')[0].trim().toLowerCase() === 'application/x-www-form-urlencoded')? requestAsUriEncode : $http.defaults.transformResponse
				,'responseType': 'json'
			})
				.then(function(response){
					angular.forEach(response.data.links, function(link){
						if((link.rel === 'main') && (link.type === 'redirect')){
							$location.path(link.href);

							$mdToast.show(
								$mdToast.simple()
									.content('redirect to ' + link.rel)
							);
						}
					});
				},function(response){
					$mdToast.show(
						$mdToast.simple()
							.content(response.statusText)
					);
				})
			;
		};

		$scope.exitMode = function(){
			if(typeof $scope.model.data != 'undefined') $scope.model.data = angular.copy(model.data);

			if(typeof model.mode != 'undefined'){
				$scope.historyBack();
			} else{
				$scope.mode = null;
			}
		};

		$scope.historyBack = function(){
			$window.history.back();
		};

		$scope.showModel = function(){
			console.log($scope.model);
		};

		$scope.showScope = function(){
			console.log($scope);
		};
	});

	app.controller('AppViewCheckboxDomainController', function($scope, $attrs, $http){
		$scope.items = [];
		$scope.isChecked = {};

		var url = null;
		angular.forEach($scope.$eval($attrs.ngLinks), function(link){
			if(link.rel == 'domain') url = link.href;
		});

		$http.get(url)
			.then(function(response){
				angular.forEach(response.data.items, function(item){
					$scope.items.push(item);

					var binded = $scope.$eval($attrs.ngModel);
					//if(typeof binded === 'undefined') binded = $scope.$eval($attrs.ngModel + ' = []');

					angular.forEach($scope.items, function(item){
						$scope.isChecked[item.data] = (binded.indexOf(item.data) > -1);
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
