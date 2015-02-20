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

			var inputProps = ['disabled', 'readonly', 'required'];

			return {
				 'strict': 'E'
				,'scope': isolateProps
				,'link': function($scope, $element, $attrs){
					var newDirectiveScope = function(){
						var newScope = $scope.$new();

						angular.forEach(isolateProps, function(attr, prop){
							var attrName = attr.replace(/^./g, '');
							var newProp = '$' + prop;

							var meta = ($scope.meta)? $scope.meta : {};
							var mode = ($scope.mode)? $scope.mode : 'self';

							if(angular.isUndefined($attrs[attrName])){
								if(inputProps.indexOf(prop) >= 0){
									if(!angular.isUndefined(meta[prop])){
										if(!angular.isUndefined(meta[prop][mode])){
											newScope[newProp] = meta[prop][mode];
										} else if(!angular.isUndefined(meta[prop]['*'])){
											newScope[newProp] = meta[prop]['*'];
										}
									}
								}
							} else{
								newScope[newProp] = $scope[prop]
							}
						});

						return newScope;
					};

					var update = function($scope){
						var meta = ($scope.$meta)? $scope.$meta : {};
						var mode = ($scope.mode)? $scope.mode : 'self';

						$scope._label = (!angular.isUndefined(meta.expression) && !angular.isUndefined(meta.expression.label))?
							$parse(meta.expression.label)($scope.$model[meta.name]) : $scope.$model[meta.name]
						;

						var template;
						if(!angular.isUndefined($scope.$template)){
							template = $scope.$template;
						} else if(!angular.isUndefined(meta.template)){
							if(!angular.isUndefined(meta.template[mode])){
								template = meta.template[mode];
							} else if(!angular.isUndefined(meta.template['*'])){
								template = meta.template['*'];
							}
						}

						if(template === null) return;

						var types = (template)? template.split('.') : ['text'];

						var templateUrl = inputDynamicPath + 'angular-input-dynamic.template/' + types[0] + '.html';
						var templateType = 'get';
						if(angular.isArray(meta.links)){
							angular.forEach(meta.links, function(link){
								if(link.rel == types[0]){
									templateUrl = link.href;
									templateType = link.type;
								}
								if(!angular.isUndefined(types[1]) && (link.rel == types[1])) $scope.$link = link;
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

					var directiveScope = $scope.$new();

					$scope.$watch('mode', function(){
						//console.log('watch mode');
						directiveScope.$destroy();
						$element.empty();

						directiveScope = newDirectiveScope();
						update(directiveScope);
					});
/*
					angular.forEach(inputProps, function(inputProp){
						$scope.$watch(inputProp, function(value, old){
							console.log(inputProp, value, old);
							if(value != old) directiveScope['$' + inputProp] = value;
						})
					});
*/
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
