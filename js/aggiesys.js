var aggiesys = angular.module('Aggiesys', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate', 'icSvg']);
window.app = aggiesys;

(function($, angular){
	'use strict';

	var modelPromise = function($q, $route, $appHttp, $mdToast){
		var defer = $q.defer();

		var url = BASEPATH + 'modules/' + $route.current.params.module + '/' + $route.current.params.operation + '.php';

		if(typeof $route.current.params.id != 'undefined'){
			url = url + '?id=' + encodeURIComponent($route.current.params.id);
		}

		$appHttp.get(url)
			.then(function(response){
				defer.resolve(response.data);
			}, function(response){
				defer.reject(response.data, response.statusText);
			})
		;

		return defer.promise;
	};

	var headersGetter = function(name, headersObj){
		name = name || '';
		headersObj = headersObj || {};

		name = name.toLowerCase();

		var value = null;
		angular.forEach(Object.getOwnPropertyNames(headersObj), function(prop){
			if(name === prop.toLowerCase()) value = value || headersObj[prop];
		});

		return value;
	};

	var requestAsUriEncodeForPhp = function(data, headers){
		if(
			   (headersGetter('Content-Type', headers()) === null)
			|| (headersGetter('Content-Type', headers()).split(';')[0].trim().toLowerCase() != 'application/x-www-form-urlencoded')
		) return data;

		var requestBodies = [];

		var deepEncodeURIComponent = function(keyConverter, data){
			if(angular.isArray(data)){
				angular.forEach(data, (function(){
					var index = 0;

					return function(value){
						deepEncodeURIComponent(function(ckey){
							return keyConverter('[' + (index++) + ']') + ckey;
						}, value);
					};
				})());
			} else if(angular.isObject(data)){
				angular.forEach(data, function(value, key){
					deepEncodeURIComponent(function(ckey){
						return keyConverter('[' + key + ']') + ckey;
					}, value);
				});
			} else{
				requestBodies.push(keyConverter('') + '=' + encodeURIComponent(data));
			}
		}

		deepEncodeURIComponent(function(ckey){
			ckey = ckey || '';
			return ckey.replace(/(^\[|\]$)/g, '');
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
					'model': function($q, $route, $appHttp, $mdToast){
						return modelPromise($q, $route, $appHttp, $mdToast);
					}
				}
			})
			.when('/:module/xxx', {
				 'templateUrl': function(params){
					return BASEPATH + 'views/list.html'
				}
				,'controller': 'ListEntityController'
				,'resolve': {
					'model': function($q, $route, $appHttp, $mdToast){
						return modelPromise($q, $appHttp, $mdToast, $route.current.params.module, 'list');
					}
				}
			})
		;

		$locationProvider.html5Mode(true);

		$httpProvider.defaults.transformRequest = (function(transform, defaults) {
			transform = angular.isArray(transform)? transform : [transform];

			return transform.concat(defaults);
		})(requestAsUriEncodeForPhp, $httpProvider.defaults.transformRequest);

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
	})
		.run(function($rootScope, $q, $timeout){
			$rootScope.loading = 0;

			$rootScope.openSidenav = function(){
				$mdSidenav('left').open();
			};

			$rootScope.progressLoad = function(promise){
				if(angular.isUndefined(promise) || !angular.isFunction(promise.finally)) return;

				$timeout(function(){
					$rootScope.loading++;

					promise.finally(function(){
						$rootScope.loading--;
					});
				}, 300);
			};

			$rootScope.testProgressLoad = function(){
				$rootScope.progressLoad($q(function(resolve, reject){
					$timeout(function(){
						resolve();
					}, 3000);
				}));
			};
		})
	;

	aggiesys.factory('$appHttp', function($rootScope, $q, $http, $mdToast){
		var $appHttp;
		angular.forEach(['', 'get', 'head', 'post','put', 'delete', 'jsonp', 'patch'], function(method){
			var $httpFn = (method === '')? $http : $http[method];

			var  $appHttpFn = function(){
				var defer = $q.defer();

				$httpFn.apply(void 0, arguments)
					.then(function(response){
						if(angular.isObject(response.data) && !angular.isUndefined(response.data.info)){
							$mdToast.show(
								$mdToast.simple()
									.content(response.data.info)
							);
						}

						defer.resolve.apply(void 0, arguments);
					}, function(response){
						var content = 'Unknown Error!!!';

						if(response instanceof Error){
							content = response.message;
						} else if(
							   !angular.isUndefined(response)
							&& !angular.isUndefined(response.data)
							&& angular.isArray(response.data.errors)
							&& !angular.isUndefined(response.data.errors[0])
						){
							content = response.data.errors[0].message;
						} else if(!angular.isUndefined(response.statusText)){
							content = response.statusText;
						}

						$mdToast.show(
							$mdToast.simple()
								.content(content)
						);

						defer.reject.apply(void 0, arguments);
					})
				;

				var promise = defer.promise;

				$rootScope.progressLoad(promise);

				return promise;
			};

			if(method === ''){
				$appHttp = $appHttpFn;
			} else{
				$appHttp[method] = $appHttpFn;
			}
		});

		return $appHttp;
	});

	aggiesys.controller('LoginController', function($scope, $appHttp, $mdToast, $location){
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

			$appHttp.post($form.attr('action'), $scope.data, {
				 'headers': {'Content-Type': $form.prop('enctype')}
			});
		};
	});

	/* GLOBAL Controller */
	app.controller('AppViewController', function($scope, $q, $appHttp, $location, $route, $window, $mdToast, $mdDialog, model){
		//console.log(model);
		$scope.model = angular.copy(model);
		$scope.mode = (typeof model.mode != 'undefined')? model.mode : null;

		var responseHandler = function(response){
			if(
				   !angular.isUndefined(response.data)
				&& angular.isArray(response.data.statuses)
			){
				var isServed = false;
				angular.forEach(response.data.statuses, function(status){
					if(isServed) return;

					if(status.uri.indexOf(model.uri) === 0){
						if(status.status === 'created'){
							$location.path(status.uri).replace();
							isServed = true;
						} else if(model.uri == status.uri){
							if(status.status === 'updated'){
								$route.reload();
								isServed = true;
							} else if(status.status === 'deleted'){
								$scope.historyBack();
								isServed = true;
							}
						}
					} else if(model.uri == status.uri){
						if(status.status === 'updated'){
							$route.reload();
							isServed = true;
						} else if(status.status === 'deleted'){
							$scope.historyBack();
							isServed = true;
						}
					}
				});
			}
		};

		$scope.execute = function(link){
			if(link.type === 'submit'){
				if(typeof $scope.model.data != 'undefined') $scope.model.data = angular.copy(model.data);

				$scope.mode = link.rel;
			} else if(link.type === 'view'){
				$location.path(link.href);
			} else{
				var promise = $q(function(resolve){
					resolve();
				});

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
					$appHttp[link.type](link.href, (['post'].indexOf(link.type) > -1)? {
						 'data': $scope.model
					} : {})
						.then(responseHandler)
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

			$appHttp.post(link.href, $scope.model.data, {
				 'headers': {'Content-Type': $form.prop('enctype')}
			})
				.then(responseHandler)
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

	app.controller('AppViewCheckboxDomainController', function($scope, $attrs, $appHttp){
		$scope.items = [];
		$scope.isChecked = {};

		var url = null;
		angular.forEach($scope.$eval($attrs.ngLinks), function(link){
			if(link.rel == 'domain') url = link.href;
		});

		$appHttp.get(url)
			.then(function(response){
				angular.forEach(response.data.items, function(item){
					$scope.items.push(item);

					var binded = $scope.$eval($attrs.ngModel);

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
