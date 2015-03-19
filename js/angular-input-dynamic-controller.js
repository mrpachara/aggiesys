(function(angular){
	'use strict';

	angular.module('inputDynamicController', ['ng', 'inputDynamic'])
		.filter('summary', function($parse){
			return function(input, expression, fixed){
				if(!angular.isArray(input)) return null;

				var accumulate = NaN;
				var parser = $parse(expression);
				angular.forEach(input, function(item){
					accumulate = ((accumulate)? accumulate : 0) + parser(item);
				});

				return (!angular.isUndefined(fixed) && angular.isNumber(accumulate))? accumulate.toFixed(fixed) : accumulate;
			};
		})
		.controller('inputDynamicNumber', function($scope, $element, $document, $timeout){
			$scope.$model = {};
			$scope.$model[$scope.$parent.$meta.name] = ($scope.$parent.$model[$scope.$parent.$meta.name])? Number($scope.$parent.$model[$scope.$parent.$meta.name]) : null;

			var $input = $element.find('input[type="number"]');

			$scope.$watch('$model[$meta.name]', function(value){
				if(angular.isNumber(value) && !angular.isUndefined($scope.$parent.$url.link.fixed)){
					value = Number(value.toFixed($scope.$parent.$url.link.fixed));
					$scope.$model[$scope.$parent.$meta.name] = value;

					if($input[0] != $document.prop('activeElement')){
						$timeout(function(){
							$input.val(value.toFixed($scope.$parent.$url.link.fixed));
						}, 100);
					}
				}
				$scope.$parent.$model[$scope.$parent.$meta.name] = value;
			});
			$scope.$watch('$parent.$model[$meta.name]', function(value){
				if(angular.isNumber(value) && !angular.isUndefined($scope.$parent.$url.link.fixed)){
					value = Number(value.toFixed($scope.$parent.$url.link.fixed));
					$scope.$parent.$model[$scope.$parent.$meta.name] = value;

					if($input[0] != $document.prop('activeElement')){
						$timeout(function(){
							$input.val(value.toFixed($scope.$parent.$url.link.fixed));
						}, 100);
					}
				}
				$scope.$model[$scope.$parent.$meta.name] = value;
			});

			if(!angular.isUndefined($scope.$parent.$url.link.fixed)){
				$input.on('blur.inputDynamicNumber', function(ev){
					$timeout(function(){
						if(angular.isNumber($scope.$model[$scope.$parent.$meta.name])){
							$input.val($scope.$model[$scope.$parent.$meta.name].toFixed($scope.$parent.$url.link.fixed));
						}
					}, 100);
				});
			}
		})
		.controller('inputDynamicDatetime', function($scope){
			$scope.$model = {};
			$scope.$model[$scope.$parent.$meta.name] = ($scope.$parent.$model[$scope.$parent.$meta.name])? new Date($scope.$parent.$model[$scope.$parent.$meta.name]) : null;

			$scope.$watch('$model[$meta.name]', function(value){
				$scope.$parent.$model[$scope.$parent.$meta.name] = (value)? value.toJSON() : null;
			});
			$scope.$watch('$parent.$model[$meta.name]', function(value){
				$scope.$model[$scope.$parent.$meta.name] = new Date(value);
			});
		})
		.controller('inputDynamicCheckboxlist', function($scope, $http, $q, $parse){
			$scope.items = [];
			$scope.itemsDirty = false;
			$scope.isChecked = {};

			if(!angular.isArray($scope.$parent.$model[$scope.$parent.$meta.name])){
				$scope.$parent.$model[$scope.$parent.$meta.name] = [];
			}

			$scope.toggleAll = function(){
				$scope.dirty();
				$scope.isChecked = {};
				if($scope.$parent.$model[$scope.$parent.$meta.name].length != $scope.items.length){
					angular.forEach($scope.items, function(item){
						$scope.isChecked[item.value] = true;
					});
				}
			};

			$scope.dirty = function(){
				$scope.itemsDirty = true;
			};

			var transformLinks = {};
			if(!angular.isUndefined($scope.$parent.$url.link.transform)){
				angular.forEach($scope.$parent.$meta.links, function(link){
					angular.forEach($scope.$parent.$url.link.transform, function(rel, key){
						if(link.rel == rel) transformLinks[key] = link;
					});
				});
			}

			$scope.transform = function(){
				$scope.itemsDirty = false;
				var dataLinks = [];

				angular.forEach(transformLinks, function(link, key){
					$scope.$parent.$model[key] = null;
				});

				angular.forEach($scope.items, function(item){
					if($scope.$parent.$model[$scope.$parent.$meta.name].indexOf(item.value) > -1){
						var dataLink = null;

						angular.forEach(item.links, function(link){
							if(dataLink !== null) return;

							if((link.rel == 'self') && link.resource) dataLink = link;
						});

						if(dataLink !== null) dataLinks.push(dataLink);
					}
				});

				var checkedDatas = [];
				var counter = dataLinks.length;
				angular.forEach(dataLinks, function(dataLink){
					$http[dataLink.type](dataLink.href)
						.then(function(response){
							checkedDatas.push(response.data.data);
						})
						.finally(function(){
							if(--counter == 0){
								angular.forEach(transformLinks, function(link, key){
									$http[link.type](link.href, checkedDatas
										,{
											 'headers': {'Content-Type': 'application/x-www-form-urlencoded'}
										}
									)
										.then(function(response){
											$scope.$parent.$model[key] = response.data;
										})
									;
								});
							}
						})
					;
				});
			};

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
							if(value){
								var meetItem = null;
								angular.forEach($scope.items, function(item){
									if(meetItem != null) return;

									if(key == item.value) meetItem = item;
								});

								$scope.$parent.$model[$scope.$parent.$meta.name].push(meetItem.value);
							}
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
		.controller('inputDynamicAutocomplete', function($scope, $element, $http, $parse, $timeout){
			var expression = {};
			angular.forEach($scope.$meta.expression, function(value, key){
				expression[key] = $parse(value);
			});

			var $input = $element.find('input');

			var defaultValue = {};
			angular.forEach($scope.$parent.$model[$scope.$parent.$meta.name], function(value, key){
				defaultValue[key] = null;
			});

			$scope.$autocomplete = {}

			$scope.$autocomplete.selectedItem = {
				 'data': $scope.$parent.$model[$scope.$parent.$meta.name]
			};

			$scope.$autocomplete.searchText = null;

			$scope.itemSearch = function(searchText){
				return (searchText)? $http[$scope.$parent.$url.link.type]($scope.$parent.$url.link.href + '?term=' + encodeURIComponent(searchText))
					.then(function(response){
						return response.data.items;
					})
				: [];
			};

			$scope.$watch('$autocomplete.selectedItem', function(value){
				$scope.$parent.$model[$scope.$parent.$meta.name] = (!angular.isUndefined(value))? value.data : defaultValue;
				$scope.$autocomplete.searchText = '';

				if($scope.$parent.$meta['required'] && (angular.equals($scope.$parent.$model[$scope.$parent.$meta.name], defaultValue))){
					$input.attr('required', 'required');
				} else{
					$input.removeAttr('required');
				}
			});

			$element.on('blur.inputDynamicSelect', 'input', function(ev){
				$timeout(function(){
					$scope.$autocomplete.searchText = '';
				}, 300);
			});

		})
		.controller('inputDynamicDatalist', function($scope, $element, $timeout){
			$scope.$summary = {};
			var meta = ($scope.$parent.$meta)? $scope.$parent.$meta : {};

			if(!angular.isArray($scope.$parent.$model[meta.name])){
				$scope.$parent.$model[$scope.$parent.$meta.name] = [];
			}

			$scope.addItem = function(){
				$timeout(function(){
					var $addItem = $element.find('#input-dynamic-datalist-addItem');
					$addItem.blur();
				}, 100);
				$scope.$parent.$model[meta.name].push({});
			};

			$scope.delItem = function(index){
				$scope.$parent.$model[meta.name].splice(index, 1);
			};
		})
	;
})(this.angular);
