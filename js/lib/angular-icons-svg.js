(function (window, document, angular){
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
					,'$get': function(){
						return {};
					}
				};
			});
		})
		.run(function($window, $http){
			var domParser = (new $window.DOMParser());

			if(typeof prop['url'] != 'undefined'){
				promise = $http.get(prop['url'])
					.success(function(svgString){
						var svg = domParser.parseFromString(svgString, 'image/svg+xml');

						var svgElem = svg.documentElement;
						svgElem.removeAttribute('width');
						svgElem.removeAttribute('height');
						svgElem.removeAttribute('viewBox');

						angular.forEach(svgElem.children, function(elem){
							if(elem.nodeName.toLowerCase() === 'svg'){
								var symbolElem = svg.createElementNS('http://www.w3.org/2000/svg', 'symbol');
								symbolElem.setAttribute('id', elem.getAttribute('id'));
								symbolElem.setAttribute('viewBox', elem.getAttribute('viewBox'));

								angular.element(symbolElem).append(elem.childNodes);
								svgElem.replaceChild(symbolElem, elem);
							}
						});
						var svgChildNodes = svgElem.childNodes;

						var defsElem = svg.createElementNS('http://www.w3.org/2000/svg', 'defs');
						angular.element(defsElem).append(svgChildNodes);
						svgElem.appendChild(defsElem);

						angular.element('head').append(document.importNode(svgElem, true));

						return svg;
					})
					.error(function(svg){
						console.log(svg);

						return svg;
					})
				;
			}
		})
		.directive('icSvg', function(){
			return {
				 'strict': 'EAC'
				,'link': function($scope, $element, $attrs){
					return promise.then(function(){
						//$scope.$watch($attrs.icHref, function(value){
							$element.empty();

							var svgElem = $element.prop('ownerDocument').createElementNS('http://www.w3.org/2000/svg', 'svg');
							var useElem = $element.prop('ownerDocument').createElementNS('http://www.w3.org/2000/svg', 'use');
							useElem.setAttributeNS('http://www.w3.org/1999/xlink', 'href', $attrs.icHref);

							svgElem.appendChild(useElem);

							$element.append(svgElem);
						//});
					});
				}
			};
		})
	;
})(this, this.document, this.angular);
