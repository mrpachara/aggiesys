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
		.directive('inputDynamic', function($http, $compile, $parse){
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

					$scope.$url = {
						 'href': null
						,'link': {}
					};

					$scope.$input = {};

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
							$scope.$url = {
								 'url': null
								,'link': {}
							};
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
				}
			};
		})
		.controller('inputDynamicNumber', function($scope){
			$scope.$model = {};
			$scope.$model[$scope.$parent.$meta.name] = ($scope.$parent.$model[$scope.$parent.$meta.name])? Number($scope.$parent.$model[$scope.$parent.$meta.name]) : null;

			$scope.$watch('$model[$meta.name]', function(value){
				$scope.$parent.$model[$scope.$parent.$meta.name] = value;
			});
		})
		.controller('inputDynamicDatetime', function($scope){
			$scope.$model = {};
			$scope.$model[$scope.$parent.$meta.name] = ($scope.$parent.$model[$scope.$parent.$meta.name])? new Date($scope.$parent.$model[$scope.$parent.$meta.name]) : null;

			$scope.$watch('$model[$meta.name]', function(value){
				$scope.$parent.$model[$scope.$parent.$meta.name] = (value)? value.toJSON() : null;
			});
		})
		.controller('inputDynamicCheckboxlist', function($scope, $http){
			$scope.items = [];
			$scope.isChecked = {};

			if(!angular.isArray($scope.$parent.$model[$scope.$parent.$meta.name])){
				$scope.$parent.$model[$scope.$parent.$meta.name] = [];
			}

			$http[$scope.$parent.$url.link.type]($scope.$parent.$url.link.href)
				.then(function(response){
					angular.forEach(response.data.items, function(item){
						$scope.items.push(item);

						angular.forEach($scope.items, function(item){
							$scope.isChecked[item.value] = ($scope.$parent.$model[$scope.$parent.$meta.name].indexOf(item.value) > -1);
						});
					});

					$scope.$watchCollection('isChecked', function(values){
						$scope.$parent.$model[$scope.$parent.$meta.name] = [];

						angular.forEach(values, function(value, key){
							if(value) $scope.$parent.$model[$scope.$parent.$meta.name].push(key);
						});
					});

				})
			;
		})
		.controller('inputDynamicRadiogroup', function($scope, $http){
			$scope.items = [];

			$http[$scope.$parent.$url.link.type]($scope.$parent.$url.link.href)
				.then(function(response){
					angular.forEach(response.data.items, function(item){
						$scope.items.push(item);
					});
				})
			;
		})
		.controller('inputDynamicSelect', function($scope, $http, $parse, $timeout, $element){
			var expression = {};
			angular.forEach($scope.$meta.expression, function(value, key){
				expression[key] = $parse(value);
			});

			$scope.$select = {}

			$scope.$select.selectedItem = {
				 'data': $scope.$parent.$model[$scope.$parent.$meta.name]
			};

			$scope.$select.searchText = null;

			$scope.itemSearch = function(searchText){
				return (searchText)? $http[$scope.$parent.$url.link.type]($scope.$parent.$url.link.href + '?term=' + encodeURIComponent(searchText))
					.then(function(response){
						return response.data.items;
					})
				: [];
			};

			$scope.$watch('$select.selectedItem', function(value){
				$scope.$parent.$model[$scope.$parent.$meta.name] = (!angular.isUndefined(value))? value.data : {};

				if(!angular.isUndefined(expression['label'])){
					$scope.$select.searchText = expression['label']($scope.$parent.$model[$scope.$parent.$meta.name]);
				} else{
					$scope.$select.searchText = value.label;
				}
			});

			$element.on('blur.inputDynamicSelect', 'input', function(ev){
				if(!angular.isUndefined(expression['label'])){
					$scope.$select.searchText = expression['label']($scope.$parent.$model[$scope.$parent.$meta.name]);
				} else{
					$scope.$select.searchText = $scope.$select.selectedItem.label;
				}
				$timeout(function(){
					$scope.$apply();
				}, 500);
			});

		})
		.controller('inputDynamicDatalist', function($scope){
			if(!angular.isArray($scope.$parent.$model[$scope.$parent.$meta.name])){
				$scope.$parent.$model[$scope.$parent.$meta.name] = [];
			}

			$scope.addItem = function(){
				$scope.$parent.$model[$scope.$parent.$meta.name].push({});
			};

			$scope.delItem = function(index){
				$scope.$parent.$model[$scope.$parent.$meta.name].splice(index, 1);
			};
		})
	;
})(this.angular);
