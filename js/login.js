var aggiesys = angular.module('Aggiesys', ['ngMaterial', 'ngMessages', 'ngAnimate', 'icSvg']);
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

	aggiesys.config(function($httpProvider, $icSvgProvider, $mdToastProvider){
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
		.run(function($rootScope, $q, $timeout, $document){
			$rootScope.appViewTitle = '';

			$rootScope.loading = 0;

			$rootScope.appProgressLoad = function(promise){
				if(angular.isUndefined(promise) || !angular.isFunction(promise.finally)) return;

				$timeout(function(){
					$rootScope.loading++;

					promise.finally(function(){
						$rootScope.loading--;
					});
				}, 300);
			};
		});
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

	aggiesys.controller('LoginController', function($scope, $appHttp, $mdToast, $timeout, $window){
		$scope.data = {
			 'username': ''
			,'password': ''
		};

		$scope.errors = [];

		$scope.submit = function(ev){
			ev.preventDefault();
			var $form = $(ev.delegateTarget);

			$appHttp.post($form.attr('action'), $scope.data, {
				 'headers': {'Content-Type': $form.prop('enctype')}
			})
				.then(function(reponse){
					$timeout(function(){
						$window.location.reload(true);
					}, 500);
				})
			;
		};
	});
})(this.jQuery, this.angular);
