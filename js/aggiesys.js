var aggiesys = angular.module('Aggiesys', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate', 'icSvg', 'inputDynamic']);
window.app = aggiesys;

(function($, angular){
	'use strict';

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

	var requestAsUriEncodeForPhp = function(data){
		var requestBodies = [];

		var deepEncodeURIComponent = function(keyConverter, data){
			if(angular.isObject(data)){
				angular.forEach(data, function(value, key){
					if(angular.isString(key) && (key.indexOf('$') == 0)) return;
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

	var modelPromise = function($q, $route, $location, $appHttp, $mdToast){
		var defer = $q.defer();

		var url = BASEPATH + 'modules/' + $route.current.params.module + '/' + $route.current.params.operation + '.php';

		var params = {};
		if(!angular.isUndefined($route.current.params.id)){
			angular.extend(params, {
				'id': $route.current.params.id
			})
		}
		angular.extend(params, $location.search(), $location.state());

		if(angular.isUndefined(params['page'])) params['page'] = 1;

		var query = requestAsUriEncodeForPhp(params);

		if(query != ''){
			url = url + '?' + query;
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

	aggiesys.config(function($routeProvider, $locationProvider, $httpProvider, $icSvgProvider, $mdToastProvider, $inputDynamicProvider){
		$routeProvider
			.when('/', {
				 redirectTo:'/delivery'
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
					'model': function($q, $route, $location, $appHttp, $mdToast){
						return modelPromise($q, $route, $location, $appHttp, $mdToast);
					}
				}
			})
		;

		$locationProvider.html5Mode(true);

		$httpProvider.defaults.transformRequest = (function(transform, defaults) {
			transform = angular.isArray(transform)? transform : [transform];

			return transform.concat(defaults);
		})(function(data, headers){
			if(
				   (headersGetter('Content-Type', headers()) === null)
				|| (headersGetter('Content-Type', headers()).split(';')[0].trim().toLowerCase() != 'application/x-www-form-urlencoded')
			) return data;

			return requestAsUriEncodeForPhp(data);
		}, $httpProvider.defaults.transformRequest);

		$icSvgProvider
			.url(BASEPATH + 'icons/material-design-icons/links.php')
			.svgTransform(function(svg){
				var svgFragment = svg.createDocumentFragment();

				angular.forEach(svg.documentElement.childNodes, function(node){
					if((node.nodeType === svg.ELEMENT_NODE) && (node.nodeName.toLowerCase() === 'svg')){
						var symbolElem = svg.createElementNS('http://www.w3.org/2000/svg', 'symbol');
						//var symbolElem = svg.createElementNS('http://www.w3.org/2000/svg', 'svg');
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
				newSvgElem.setAttribute('version', '1.1');
				newSvgElem.appendChild(svgFragment);

				svg.replaceChild(newSvgElem, svg.documentElement);

				return svg;
			})
		;

		$inputDynamicProvider
			.basePath(BASEPATH + 'template/angular-input-dynamic.template/')
		;
	})
		.run(function($rootScope, $q, $timeout, $location, $mdSidenav, $document){
			$rootScope.appViewTitle = '';

			$rootScope.loading = 0;
			$rootScope.$mdSidenav = $mdSidenav;

			$rootScope.appProgressLoad = function(promise){
				if(angular.isUndefined(promise) || !angular.isFunction(promise.finally)) return;

				$timeout(function(){
					$rootScope.loading++;

					promise.finally(function(){
						$rootScope.loading--;
					});
				}, 300);
			};

			$rootScope.appTestProgressLoad = function(){
				$rootScope.appProgressLoad($q(function(resolve, reject){
					$timeout(function(){
						resolve();
					}, 3000);
				}));
			};

			$rootScope.appIsHasViewSearch = false;
			$rootScope.appIsActiveViewSearch = false;
			$rootScope.appViewSearchText = '';
			$rootScope.appViewSearchTerm = '';

			$rootScope.appActiveViewSearch = function(ev, searchText){
				if(!$rootScope.appIsActiveViewSearch){
					if(!angular.isUndefined(ev)) ev.preventDefault();

					$rootScope.appIsActiveViewSearch = true;

					$timeout(function(){
						angular.element('#app-cp-view-search .app-cl-search-box>input').focus();
					}, 200);
				}

				if(!angular.isUndefined(searchText)) $rootScope.appViewSearchText = searchText;
			};

			$rootScope.appDeactiveViewSearch = function(ev){
				if(($rootScope.appViewSearchText === '') && ($rootScope.appViewSearchTerm === '')){
					$rootScope.appIsActiveViewSearch = false;
				}
			};

			$rootScope.appSubmitViewSearch = function(ev, searchText){
				ev.preventDefault();

				$rootScope.appViewSearchTerm = $rootScope.appViewSearchText;

				$location
					.search(($rootScope.appViewSearchTerm != '')? {'term': $rootScope.appViewSearchTerm} : {})
					.replace()
				;

				$rootScope.appDeactiveViewSearch();
			};

			$rootScope.$on('$locationChangeSuccess', function(ev, oldUrl, newUrl){
				var search = $location.search();

				if(!angular.isUndefined(search.term)){
					$rootScope.appViewSearchText = $rootScope.appViewSearchTerm = search.term;
				} else{
					$rootScope.appViewSearchText = $rootScope.appViewSearchTerm = '';
				}

				if($rootScope.appViewSearchTerm != '') $rootScope.appIsActiveViewSearch = true;
			});
		});
	;

	aggiesys.filter('model', function($parse){
		return function(input, mode, meta){
			if((mode === null) && !angular.isUndefined(meta.expression) && !angular.isUndefined(meta.expression.display)){
				return $parse(meta.expression.display)(input);
			} else{
				return input;
			}
		};
	});

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

				$rootScope.appProgressLoad(promise);

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

	/* GLOBAL Controller */
	app.controller('AppViewController', function($scope, $rootScope, $q, $appHttp, $location, $route, $window, $mdToast, $mdDialog, model){
		//console.log(model);
		$scope.model = angular.copy(model);
		$scope.mode = (typeof model.mode != 'undefined')? model.mode : null;

		if(angular.isString(model.uri)) $rootScope.appViewTitle = model.uri.replace(/\//g, ' > ');

		var isHasViewSearch = false;
		angular.forEach(model.links, function(link){
			if(link.rel == 'search') isHasViewSearch = true;
		});
		$rootScope.appIsHasViewSearch = isHasViewSearch;


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
							$location.url(status.uri).replace();
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
			if(angular.isUndefined(link)) return;

			if(link.type === 'submit'){
				!angular.isUndefined($scope.model.data)
				if(!angular.isUndefined($scope.model.data)) $scope.model.data = angular.copy(model.data);

				$scope.mode = link.rel;
			} else if((link.type === 'search') && !angular.isUndefined(link.query)){
				/*
				angular.forEach(link.query, function(value, key){
					$location.search(key, value);
				});
				$location.replace();
				*/
			} else if((link.type === 'state') && (link.state != null)){
				/*
					IMPORTANT:
					state must be created from new Object unless state doesn't store in history.state.
					may be angular $location cache state object and will replace/pushState when new state not equal with old onec
				*/
				var state = angular.extend({}, ($location.state() != null)? $location.state() : {}, link.state);

				$location.state(state).replace();
			} else if(link.type === 'view'){
				$location.url(link.href);
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

			if(!angular.isUndefined(model.mode)){
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
						$scope.isChecked[item.value] = (binded.indexOf(item.value) > -1);
					});
				});

				$scope.$watchCollection('isChecked', function(values){
					var binded = $scope.$eval($attrs.ngModel);
					binded.splice(0, binded.length);

					angular.forEach(values, function(value, key){
						if(value) binded.push(key);
					});
				});
			})
		;
	});
})(this.jQuery, this.angular);
