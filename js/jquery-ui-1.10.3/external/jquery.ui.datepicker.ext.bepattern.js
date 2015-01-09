(function($, undefined){
	var d_parseDate = $.datepicker.parseDate;
	var d_formatDate = $.datepicker.formatDate;
	var d__inlineDatepicker = $.datepicker._inlineDatepicker;
	var d__updateDatepicker = $.datepicker._updateDatepicker;
	var d__showDatepicker = $.datepicker._showDatepicker;
	
	var changeToBE = function(inst){
		var dateFormat = $.datepicker._get(inst, "dateFormat");
		if((dateFormat !== undefined) && (dateFormat !== null) && (dateFormat.match(/be/g))){
			var $uiyear = $('.ui-datepicker-year:not(.ui-datepicker-ext-bepattern-yearbe)', inst.dpDiv);
			
			$uiyear.each(function(index){
				var $this = $(this);
				if($this.prop('tagName').toLowerCase() == 'select'){
					$this.find('option').each(function(index){
						var $_this = $(this);
						$_this.text(parseInt($_this.text()) + 543);
					});
				} else{
					$this.text(parseInt($this.text()) + 543);
				}
				/* to prevent duplicate call set add class ui-datepicker-ext-bepattern-yearbe */
				$this.addClass('ui-datepicker-ext-bepattern-yearbe');
			});
		}
	}
	
	$.extend($.datepicker, {
		'parseDate': function(format, value, settings){
			if((format !== undefined) && (format !== null) && (format.match(/be/g))){
				format = format.replace(/be/g, 'yy');
				
				/* ==== START: code from jquery.ui.datepicker function parseDate v.1.10.3 ==== */
				if (format == null || value == null) {
					throw "Invalid arguments";
				}
				
				value = (typeof value === "object" ? value.toString() : value + "");
				if (value === "") {
					return null;
				}
				
				var iFormat, dim, extra,
					iValue = 0,
					shortYearCutoffTemp = (settings ? settings.shortYearCutoff : null) || this._defaults.shortYearCutoff,
					shortYearCutoff = (typeof shortYearCutoffTemp !== "string" ? shortYearCutoffTemp :
						new Date().getFullYear() % 100 + parseInt(shortYearCutoffTemp, 10)),
					dayNamesShort = (settings ? settings.dayNamesShort : null) || this._defaults.dayNamesShort,
					dayNames = (settings ? settings.dayNames : null) || this._defaults.dayNames,
					monthNamesShort = (settings ? settings.monthNamesShort : null) || this._defaults.monthNamesShort,
					monthNames = (settings ? settings.monthNames : null) || this._defaults.monthNames,
					year = -1,
					month = -1,
					day = -1,
					doy = -1,
					literal = false,
					date,
					// Check whether a format character is doubled
					lookAhead = function(match) {
						var matches = (iFormat + 1 < format.length && format.charAt(iFormat + 1) === match);
						if (matches) {
							iFormat++;
						}
						return matches;
					},
					// Extract a number from the string value
					getNumber = function(match) {
						var isDoubled = lookAhead(match),
							size = (match === "@" ? 14 : (match === "!" ? 20 :
							(match === "y" && isDoubled ? 4 : (match === "o" ? 3 : 2)))),
							digits = new RegExp("^\\d{1," + size + "}"),
							num = value.substring(iValue).match(digits);
						if (!num) {
							throw "Missing number at position " + iValue;
						}
						iValue += num[0].length;
						return parseInt(num[0], 10);
					},
					// Extract a name from the string value and convert to an index
					getName = function(match, shortNames, longNames) {
						var index = -1,
							names = $.map(lookAhead(match) ? longNames : shortNames, function (v, k) {
								return [ [k, v] ];
							}).sort(function (a, b) {
								return -(a[1].length - b[1].length);
							});
						
						$.each(names, function (i, pair) {
							var name = pair[1];
							if (value.substr(iValue, name.length).toLowerCase() === name.toLowerCase()) {
								index = pair[0];
								iValue += name.length;
								return false;
							}
						});
						if (index !== -1) {
							return index + 1;
						} else {
							throw "Unknown name at position " + iValue;
						}
					},
					// Confirm that a literal character matches the string value
					checkLiteral = function() {
						if (value.charAt(iValue) !== format.charAt(iFormat)) {
							throw "Unexpected literal at position " + iValue;
						}
						iValue++;
					};
				
				for (iFormat = 0; iFormat < format.length; iFormat++) {
					if (literal) {
						if (format.charAt(iFormat) === "'" && !lookAhead("'")) {
							literal = false;
						} else {
							checkLiteral();
						}
					} else {
						switch (format.charAt(iFormat)) {
							case "d":
								day = getNumber("d");
								break;
							case "D":
								getName("D", dayNamesShort, dayNames);
								break;
							case "o":
								doy = getNumber("o");
								break;
							case "m":
								month = getNumber("m");
								break;
							case "M":
								month = getName("M", monthNamesShort, monthNames);
								break;
							case "y":
								year = getNumber("y");
								/* 
									My hack code:
									It's always double y (yy)
								*/
								year -= 543;
								break;
							case "@":
								date = new Date(getNumber("@"));
								year = date.getFullYear();
								month = date.getMonth() + 1;
								day = date.getDate();
								break;
							case "!":
								date = new Date((getNumber("!") - this._ticksTo1970) / 10000);
								year = date.getFullYear();
								month = date.getMonth() + 1;
								day = date.getDate();
								break;
							case "'":
								if (lookAhead("'")){
									checkLiteral();
								} else {
									literal = true;
								}
								break;
							default:
								checkLiteral();
						}
					}
				}
				
				if (iValue < value.length){
					extra = value.substr(iValue);
					if (!/^\s+/.test(extra)) {
						throw "Extra/unparsed characters found in date: " + extra;
					}
				}
				
				if (year === -1) {
					year = new Date().getFullYear();
				} else if (year < 100) {
					year += new Date().getFullYear() - new Date().getFullYear() % 100 +
						(year <= shortYearCutoff ? 0 : -100);
				}
				
				if (doy > -1) {
					month = 1;
					day = doy;
					do {
						dim = this._getDaysInMonth(year, month - 1);
						if (day <= dim) {
							break;
						}
						month++;
						day -= dim;
					} while (true);
				}
				
				date = this._daylightSavingAdjust(new Date(year, month - 1, day));
				if (date.getFullYear() !== year || date.getMonth() + 1 !== month || date.getDate() !== day) {
					throw "Invalid date"; // E.g. 31/02/00
				}
				return date;
				
				/* ==== END: code from jquery.ui.datepicker function parseDate v.1.10.3 ==== */
			} else{
				return d_parseDate.apply(this, arguments);
			}
		},
		
		'formatDate': function(format, date, settings){
			var isBE = false;
			if((format !== undefined) && (format !== null) && (format.match(/be/g))){
				isBE = true;
				format = format.replace(/be/g, '{yy}');
			}
			
			var strformat = d_formatDate.apply(this, arguments);
			
			if(isBE && (strformat !== undefined) && (strformat !== null)){
				var cepattern = /\{[0-9]*\}/g;
				var cegreeting = cepattern.exec(strformat)[0];
				var beyear = parseInt(cegreeting.substring(1, cegreeting.length - 1)) + 543;
				strformat = strformat.replace(cegreeting, beyear);
			}
			
			return strformat;
		},
		
		'_inlineDatepicker': function(target, inst){
			d__inlineDatepicker.apply(this, arguments);
			
			changeToBE(inst);
		},
		
		'_updateDatepicker': function(inst){
			d__updateDatepicker.apply(this, arguments);
			
			changeToBE(inst);
			
			/* There are some code of _updateDatepicker has setTimeout to update year, so make it too*/
			var origyearshtml;
			if(inst.yearshtml){
				setTimeout(function(){
					//assure that inst.yearshtml didn't change.
					changeToBE(inst);
				}, 0);
			}
		},
		
		'_showDatepicker': function(input){
			d__showDatepicker.apply(this, arguments);
			
			input = input.target || input;
			if (input.nodeName.toLowerCase() !== "input") { // find from button/image trigger
				input = $("input", input.parentNode)[0];
			}
			
			var inst = $.datepicker._getInst(input);
			
			changeToBE(inst);
		}
	});
})(jQuery);