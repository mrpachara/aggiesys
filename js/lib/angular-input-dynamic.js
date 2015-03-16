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
		.directive('inputDynamic', function($http, $compile, $parse, $timeout){
			var applyTemplate = function($scope, $element, html){
				$element.html(html);
				$compile($element.contents())($scope);
			};

			var isolateProps = {
				 '$model': '=ngModel'
				,'$disabled': '=ngDisabled'
				,'$readonly': '=ngReadonly'
				,'$required': '=ngRequired'
				,'$template': '=inputTemplate'
				,'$mode': '=inputMode'
				,'$meta': '=inputMeta'
				,'$form': '=inputForm'
			};

			var inputProps = ['template', 'disabled', 'readonly', 'required'];

			return {
				 'strict': 'E'
				,'scope': isolateProps
				,'template': '<ng-include src="$url.href"></ng-include>'
				,'link': function($scope, $element, $attrs){
					$scope._label = (
						   !angular.isUndefined($scope.$meta)
						&& !angular.isUndefined($scope.$meta.expression)
						&& !angular.isUndefined($scope.$meta.expression.label)
					)?
						$parse($scope.$meta.expression.label)($scope.$model[$scope.$meta.name]) : $scope.$model[$scope.$meta.name]
					;

					var defaultUrl = {
						 'href': null
						,'link': {}
					};

					var defaultInput = {
						 'isHasCalculate': false
						,'isAutoCalculate': true
						,'toggleAutoCalculate': function(){
							var meta = ($scope.$meta)? $scope.$meta : {};
							$scope.$input['isAutoCalculate'] = !$scope.$input['isAutoCalculate'];
						}
					};

					$scope.$url = angular.extend({}, defaultUrl);
					$scope.$input = angular.extend({}, defaultInput);

					angular.forEach(inputProps, function(prop){
						var scopePropName = '$' + prop;

						if(!angular.isUndefined($attrs[isolateProps[scopePropName].replace(/^./,'')])){
							$scope.$watch(scopePropName, function(value){
								$scope.$input[prop] = value;
							});
						}
					});

					$scope.$watch('$input.template', function(value){
						if(value === null){
							$scope.$url = angular.extend({}, defaultUrl);
						} else{
							var meta = ($scope.$meta)? $scope.$meta : {};
							var template = (angular.isUndefined(value))? 'text' : value;

							var templates = template.split('.');
							var url = {
								 'href': inputDynamicPath + templates[0] + '.html'
								,'link': null
							};

							if(angular.isArray(meta.links)){
								angular.forEach(meta.links, function(link){
									if(link.rel == templates[0]){
										url.href = link.href;
									}
									if(!angular.isUndefined(templates[1]) && (link.rel == templates[1])) url.link = link;
								});
							}

							$scope.$url = url;
						}
					});

					$scope.$watch('$mode', function(value){
						//$scope.$input = angular.extend({}, defaultInput);
						angular.forEach(inputProps, function(prop){
							var scopePropName = '$' + prop;
							var meta = ($scope.$meta)? $scope.$meta : {};
							var mode = (value === null)? 'self' : value;

							if(angular.isUndefined($attrs[isolateProps[scopePropName].replace(/^./,'')])){
								if(!angular.isUndefined(meta[prop])){
									if(!angular.isUndefined(meta[prop][mode])){
										$scope.$input[prop] = meta[prop][mode];
									} else if(!angular.isUndefined(meta[prop]['*'])){
										$scope.$input[prop] = meta[prop]['*'];
									}
								}
							}
						});
					});

					(function(){
						$scope.$input['isHasCalculate'] = false;
						$scope.$input['isAutoCalculate'] = true;
						var meta = ($scope.$meta)? $scope.$meta : {};
						angular.forEach(meta.expression, function(expression, key){
							if(key != 'calculate') return;

							$scope.$input['isHasCalculate'] = true;
							if(!angular.isUndefined($scope.$model[meta.name]) && ($scope.$model[meta.name] !== null)) $scope.$input['isAutoCalculate'] = false;

							var parser = $parse(expression);
							$scope.$watch(function(scope){
								if($scope.$input['isAutoCalculate']) scope.$model[meta.name] = parser(scope.$model);
							});
						});
					})();
				}
			};
		})
	;
})(this.angular);
