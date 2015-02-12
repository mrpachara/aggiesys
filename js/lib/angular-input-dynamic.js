(function(angular){
	'use strict';

	var inputDynamicPath = '';

	var templateCache = {};

	angular.module('inputDynamic', ['ng'])
		.config(function($provide){
			$provide.provider('$inputDynamic', function(){
				return {
					 'basePath': function(basePath){
						inputDynamicPath = basePath;

						return this;
					}
					,'$get': function(){
						return {
							 'getBasePath': function(){
								return inputDynamicPath;
							}
						};
					}
				};
			});
		})
		.run(function(){

		})
		.directive('inputDynamic', function($http, $compile){
			var applyTemplate = function($scope, $element, html){
				$element.html(html);
				$compile($element.contents())($scope);
			};

			return {
				 'strict': 'E'
				,'scope': {
					 'data': '=inputModel'
					,'mode': '=inputMode'
					,'meta': '=inputMeta'
					,'form': '=inputForm'
				}
				,'link': function($scope, $element, $attrs){
					var update = function(){
						var types = ['text'];
						var meta = ($scope.meta)? $scope.meta : {};

						var mode = ($scope.mode)? $scope.mode : 'self';
						if(
							   !angular.isUndefined(meta.display)
							&& !angular.isUndefined(meta.display[mode])
						){
							types = meta.display[mode].split('.');
						}

						if(!angular.isUndefined(types[1]) && angular.isArray(meta.links)){
							angular.forEach(meta.links, function(link){
								if(link.rel == types[1]) $scope.link = link;
							});
						}

						var templateUrl = inputDynamicPath + 'angular-input-dynamic.template/' + types[0] + '.html';
						if(angular.isUndefined(templateCache[templateUrl])){
							$http.get(templateUrl)
								.then(function(response){
									templateCache[templateUrl] = response.data;
									applyTemplate($scope, $element, response.data);
								})
							;
						} else{
							applyTemplate($scope, $element, templateCache[templateUrl]);
						}
					};

					$scope.$watch('mode', function(newValue, oldValue){
						if(newValue != oldValue) update();
					});

					update();
				}
			};
		})
		.controller('inputDynamicCheckboxlist', function($scope, $http, $compile){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});
			$scope.items = [];
			$scope.isChecked = {};

			$http[$scope.link.type]($scope.link.href)
				.then(function(response){
					angular.forEach(response.data.items, function(item){
						$scope.items.push(item);

						angular.forEach($scope.items, function(item){
							$scope.isChecked[item.value] = ($scope.data.indexOf(item.value) > -1);
						});
					});

					$scope.$watchCollection('isChecked', function(values){
						$scope.data.splice(0, $scope.data.length);

						angular.forEach(values, function(value, key){
							if(value) $scope.data.push(key);
						});
					});

				})
			;
		})
		.controller('inputDynamicDatalist', function($scope, $http, $compile){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});

			$scope.addItem = function(){
				$scope.data.push({});
			};
		})
	;
})(this.angular);
