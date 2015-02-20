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
				 'model': '=ngModel'
				,'disabled': '=ngDisabled'
				,'readonly': '=ngReadonly'
				,'required': '=ngRequired'
				,'template': '=inputTemplate'
				,'mode': '=inputMode'
				,'meta': '=inputMeta'
				,'form': '=inputForm'
			};

			var inputProps = ['template', 'disabled', 'readonly', 'required'];

			return {
				 'strict': 'E'
				,'scope': isolateProps
				,'template': '<ng-include src="\'http://localhost/aggiesys/js/lib/angular-input-dynamic.template/text.html\'"></ng-include>'
				,'link': function($scope, $element, $attrs){
					$scope._label = (
						   !angular.isUndefined($scope.$meta)
						&& !angular.isUndefined($scope.$meta.expression)
						&& !angular.isUndefined($scope.$meta.expression.label)
					)?
						$parse($scope.$meta.expression.label)($scope.$model[meta.name]) : $scope.$model[$scope.$meta.name]
					;

					angular.forEach(isolateProps, function(){
						
					});

					$scope.$url = {
						 'href': inputDynamicPath + 'angular-input-dynamic.template/text.html'
						,'link': {}
					};

					$scope.$watch('$template', function(value){
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
								 'href': inputDynamicPath + 'angular-input-dynamic.template/' + templates[0] + '.html'
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

							if(angular.isUndefined($attrs[isolateProps[scopePropName]])){
								if(!angular.isUndefined(meta[prop])){
									if(!angular.isUndefined(meta[prop][mode])){
										$scope[scopePropName] = meta[prop][mode];
									} else if(!angular.isUndefined(meta[prop]['*'])){
										$scope[scopePropName] = meta[prop]['*'];
									}
								}
							}
						});
					});
				}
			};
		})
		.controller('inputDynamicDatetime', function($scope){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});

			$scope.datetime = ($scope.$model[$scope.$meta.name])? new Date($scope.$model[$scope.$meta.name]) : null;

			$scope.$watch('datetime', function(value){
				if(value){
					$scope.$model[$scope.$meta.name] = value.toJSON();
				}
			});
		})
		.controller('inputDynamicCheckboxlist', function($scope, $http){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});
			$scope.items = [];
			$scope.isChecked = {};

			if(!angular.isArray($scope.$model[$scope.$meta.name])){
				$scope.$model[$scope.$meta.name] = $scope.$parent.$model[$scope.$meta.name] = [];
			}

			$http[$scope.$link.type]($scope.$link.href)
				.then(function(response){
					angular.forEach(response.data.items, function(item){
						$scope.items.push(item);

						angular.forEach($scope.items, function(item){
							$scope.isChecked[item.value] = ($scope.$model[$scope.$meta.name].indexOf(item.value) > -1);
						});
					});

					$scope.$watchCollection('isChecked', function(values){
						$scope.$model[$scope.$meta.name].splice(0, $scope.$model[$scope.$meta.name].length);

						angular.forEach(values, function(value, key){
							if(value) $scope.$model[$scope.$meta.name].push(key);
						});
					});

				})
			;
		})
		.controller('inputDynamicRadiogroup', function($scope, $http){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});
			$scope.items = [];

			$scope.$watch('data', function(value){
				$scope.$parent.$model = value;
			});

			$http[$scope.$link.type]($scope.$link.href)
				.then(function(response){
					angular.forEach(response.data.items, function(item){
						$scope.items.push(item);
					});
				})
			;
		})
		.controller('inputDynamicSelect', function($scope, $http, $parse, $timeout, $element){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});

			var expression = {};
			angular.forEach($scope.$meta.expression, function(value, key){
				expression[key] = $parse(value);
			});

			$scope.selectedItem = {
				 'data': $scope.$model[$scope.$meta.name]
			};

			$scope.searchText = '';

			$scope.itemSearch = function(searchText){
				return (searchText)? $http[$scope.$link.type]($scope.$link.href + '?term=' + encodeURIComponent(searchText))
					.then(function(response){
						return response.data.items;
					})
				: [];
			};

			$scope.$watch('selectedItem', function(value){
				$scope.$model[$scope.$meta.name] = (!angular.isUndefined(value))? value.data : {};
console.log('selectedItem', value);
				if(!angular.isUndefined(expression['label'])){
					$scope.searchText = expression['label']($scope.$model[$scope.$meta.name]);
				} else{
					$scope.searchText = value.label;
				}
			});

			$element.on('blur.inputDynamicSelect', 'input', function(ev){
				if(!angular.isUndefined(expression['label'])){
					$scope.searchText = expression['label']($scope.$model[$scope.$meta.name]);
				} else{
					$scope.searchText = '';
				}
				$timeout(function(){
					$scope.$apply();
				}, 500);
			});

		})
		.controller('inputDynamicDatalist', function($scope){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});

			$scope.addItem = function(){
				$scope.$model[$scope.$meta.name].push({});
			};

			$scope.delItem = function(index){
				$scope.$model[$scope.$meta.name].splice(index, 1);
			};
		})
	;
})(this.angular);
