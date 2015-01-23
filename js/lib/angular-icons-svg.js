(function (angular){
	'use strict';

	var prop = {};

	var promise = null;

	angular.module('icSvg', ['ng'])
		.config(function($provide, $compileProvider) {
			$provide.provider('$icSvg', function(){
				return {
					 'url': function(url){
						prop['url'] = url;

						return this;
					}
					,'svgTransform': function(fn){
						prop['svgTransform'] = fn;

						return this;
					}
					,'$get': function(){
						return {};
					}
				};
			});
		})
		.run(function($q, $http, $window){
			var domParser = (new $window.DOMParser());

			var appendSvg = function(svgString, contentType, link){
				var svg = domParser.parseFromString(svgString, contentType);

				if(typeof prop['svgTransform'] === 'function'){
					svg = prop['svgTransform'](svg) || svg;
				}

				svg.documentElement.setAttributeNS('http://www.w3.org/1999/xhtml', 'data-src', link);
				var importedNode = $window.document.importNode(svg.documentElement, true);
				importedNode.setAttributeNS('http://www.w3.org/1999/xhtml', 'data-src', link);
				importedNode.setAttribute('style', 'display: none;');
				angular.element('head').append(importedNode);
			};

			var loadSvg = function(link){
				var defer = $q.defer();

				$http.get(link)
					.success(function(data, status, headers, config){
						if(headers('Content-Type').split(';')[0].trim().toLocaleLowerCase() === 'application/json'){
							var svgCounter = data.links.length;

							angular.forEach(data.links, function(link){
								loadSvg(link)
									.finally(function(){
										if(--svgCounter === 0){
											defer.resolve();
										}
									})
								;
							});
						} else{
							appendSvg(data, headers('Content-Type'), link);
							defer.resolve();
						}
					})
					.error(function(svg){
						defer.resolve();
					})
				;

				return defer.promise;
			};

			if(typeof prop['url'] != 'undefined'){
				promise = loadSvg(prop['url']);
			}
		})
		.directive('icSvg', function(){
			return {
				 'strict': 'EAC'
				,'link': function($scope, $element, $attrs){
					return promise.then(function(){
						$element.empty();

						var svgElem = $element.prop('ownerDocument').createElementNS('http://www.w3.org/2000/svg', 'svg');
						var useElem = $element.prop('ownerDocument').createElementNS('http://www.w3.org/2000/svg', 'use');
						useElem.setAttributeNS('http://www.w3.org/1999/xlink', 'href', $attrs.icHref);

						svgElem.appendChild(useElem);

						$element.append(svgElem);
					});
				}
			};
		})
	;
})(this.angular);
