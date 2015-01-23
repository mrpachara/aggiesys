var aggiesys = angular.module('Aggiesys', ['ngMaterial', 'ngRoute', 'ngMessages', 'ngAnimate', 'icSvg']);
window.app = aggiesys;

(function(window, document, $, angular){
	'use strict';

	aggiesys.config(function($routeProvider, $locationProvider, $icSvgProvider){
		$routeProvider
			.when('/', {
				 redirectTo:'/login'
			})
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
						symbolElem.setAttribute('preserveAspectRatio', 'xMidYMid meet')

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


	/*angular.injector().invoke(function($http){
		var $http = angular.injector().get('$http');
		$http.get(BASEPATH + 'icons/material-desing-icons/svg/svg-sprite-action.svg')
			.success(function(xml){
				console.log(xml);
			})
			.error(function(data, status, headers, config){
				console.log(status, data);
			})
		;
	});*/
})(this, this.document, this.jQuery, this.angular);
