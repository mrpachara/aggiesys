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

			return {
				 'strict': 'E'
				,'scope': {
					 'data': '=ngModel'
					,'disabled': '=ngDisabled'
					,'readonly': '=ngReadonly'
					,'required': '=ngRequired'
					,'template': '=inputTemplate'
					,'mode': '=inputMode'
					,'meta': '=inputMeta'
					,'form': '=inputForm'
				}
				,'link': function($scope, $element, $attrs){
					var $directiveScope = $scope.new();

					var newDirectiveScope = function(){
						var newScope = $scope.new();


						return newScope;
					};

					var update = function($scope){
						$scope.ctrl = {};
						var meta = ($scope.meta)? $scope.meta : {};

						$scope._label = (!angular.isUndefined(meta.expression) && !angular.isUndefined(meta.expression.label))?
							$parse(meta.expression.label)($scope.data[meta.name]) : $scope.data[meta.name]
						;

						var mode = ($scope.mode)? $scope.mode : 'self';
						angular.forEach(['disabled', 'readonly', 'required'], function(ctrlName){
							if(angular.isUndefined($attrs['ng' + ctrlName.replace(/^./, function(ch){return ch.toUpperCase()})])){
								if(!angular.isUndefined(meta[ctrlName])){
									if(!angular.isUndefined(meta[ctrlName][mode])){
										$scope.ctrl[ctrlName] = meta[ctrlName][mode];
									} else if(!angular.isUndefined(meta[ctrlName]['*'])){
										$scope.ctrl[ctrlName] = meta[ctrlName]['*'];
									}
								}
							} else{
								$scope.$watch(ctrlName, function(newValue){
									$scope.ctrl[ctrlName] = newValue;
								});
							}
						});

						var template;
						if(!angular.isUndefined($scope.template)){
							template = $scope.template;
						} else if(!angular.isUndefined(meta.template)){
							if(!angular.isUndefined(meta.template[mode])){
								template = meta.template[mode];
							} else if(!angular.isUndefined(meta.template['*'])){
								template = meta.template['*'];
							}
						}

						if(template === null){
							console.log('zzz', $scope);
							$element.empty();
							return;
						}

						var types = (template)? template.split('.') : ['text'];

						var templateUrl = inputDynamicPath + 'angular-input-dynamic.template/' + types[0] + '.html';
						var templateType = 'get';
						if(angular.isArray(meta.links)){
							angular.forEach(meta.links, function(link){
								if(link.rel == types[0]){
									templateUrl = link.href;
									templateType = link.type;
								}
								if(!angular.isUndefined(types[1]) && (link.rel == types[1])) $scope.link = link;
							});
						}

						if(angular.isUndefined(templateCache[templateUrl])){
							$http[templateType](templateUrl)
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
						console.log('watch mode');
						if(newValue != oldValue) update($directiveScope);
					});
$scope.$on('$destroy', function(){
	console.log('destroy', $scope);
});
					update($directiveScope);
				}
			};
		})
		.controller('inputDynamicDatetime', function($scope){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});

			$scope.datetime = ($scope.data[$scope.meta.name])? new Date($scope.data[$scope.meta.name]) : null;

			$scope.$watch('datetime', function(value){
				if(value){
					$scope.data[$scope.meta.name] = value.toJSON();
				}
			});
		})
		.controller('inputDynamicCheckboxlist', function($scope, $http){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});
			$scope.items = [];
			$scope.isChecked = {};

			if(!angular.isArray($scope.data[$scope.meta.name])){
				$scope.data[$scope.meta.name] = $scope.$parent.data[$scope.meta.name] = [];
			}

			$http[$scope.link.type]($scope.link.href)
				.then(function(response){
					angular.forEach(response.data.items, function(item){
						$scope.items.push(item);

						angular.forEach($scope.items, function(item){
							$scope.isChecked[item.value] = ($scope.data[$scope.meta.name].indexOf(item.value) > -1);
						});
					});

					$scope.$watchCollection('isChecked', function(values){
						$scope.data[$scope.meta.name].splice(0, $scope.data[$scope.meta.name].length);

						angular.forEach(values, function(value, key){
							if(value) $scope.data[$scope.meta.name].push(key);
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
				$scope.$parent.data = value;
			});

			$http[$scope.link.type]($scope.link.href)
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
			angular.forEach($scope.meta.expression, function(value, key){
				expression[key] = $parse(value);
			});

			$scope.selectedItem = {
				 'data': $scope.data[$scope.meta.name]
			};

			$scope.searchText = '';

			$scope.itemSearch = function(searchText){
				return (searchText)? $http[$scope.link.type]($scope.link.href + '?term=' + encodeURIComponent(searchText))
					.then(function(response){
						return response.data.items;
					})
				: [];
			};

			$scope.$watch('selectedItem', function(value){
				$scope.data[$scope.meta.name] = (!angular.isUndefined(value))? value.data : {};

				if(!angular.isUndefined(expression['label'])){
					$scope.searchText = expression['label']($scope.data[$scope.meta.name]);
				} else{
					$scope.searchText = value.label;
				}
			});

			$element.on('blur.inputDynamicSelect', 'input', function(ev){
				$timeout(function(){
					if(!angular.isUndefined(expression['label'])){
						$scope.searchText = expression['label']($scope.data[$scope.meta.name]);
					} else{
						$scope.searchText = '';
					}
					$scope.$apply();
				}, 500);
			});

		})
		.controller('inputDynamicDatalist', function($scope){
			angular.forEach($scope.$parent, function(value, key){
				if(key.indexOf('$') != 0) $scope[key] = value;
			});

			$scope.addItem = function(){
				$scope.data[$scope.meta.name].push({});
			};

			$scope.delItem = function(index){
				$scope.data[$scope.meta.name].splice(index, 1);
			};
		})
	;
})(this.angular);
