(function(angular){
	'use strict';

	var inputDynamicPath = '/aggiesys/js/lib';

	var templateCache = {};

	angular.module('inputDynamic', ['ng'])
		.config(function(){

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
console.log('iii', types[1], meta.links);
						if(!angular.isUndefined(types[1]) && angular.isArray(meta.links)){
							angular.forEach(meta.links, function(link){
								if(link.rel == types[1]) $scope.link = link;
							});
						}
console.log('xxx', types, $scope.data);
						var templateUrl = inputDynamicPath + '/angular-input-dynamic.template/' + types[0] + '.html';
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
		.directive('inputDynamicCheckboxlist', function($http){
			return {
				 'strict': 'E'
				,'link': function($scope, $element, $attrs){
					$scope.items = [];
					$scope.isChecked = {};

					$http[$scope.link.type]($scope.link.href)
						.then(function(response){
							console.log('get domain success', $scope.data.toString());
							angular.forEach(response.data.items, function(item){
								$scope.items.push(item);

								angular.forEach($scope.items, function(item){
									$scope.isChecked[item.value] = ($scope.data.indexOf(item.value) > -1);
								});
							});

							$scope.$watchCollection('isChecked', function(values){
								var binded = $scope.data;
								binded.splice(0, binded.length);

								angular.forEach(values, function(value, key){
									if(value) binded.push(key);
								});
							});
						})
					;
				}
			};
		})
	;
})(this.angular);
