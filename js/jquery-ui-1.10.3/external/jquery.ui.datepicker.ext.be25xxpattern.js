(function($, undefined){
	var d_parseDate = $.datepicker.parseDate;
	var d_formatDate = $.datepicker.formatDate;
	var d__showDatepicker = $.datepicker._showDatepicker;
	
	$.extend($.datepicker, {
		'parseDate': function(format, value, settings){
			if((format !== undefined) && (format !== null) && (format.match(/be/g))){
				format = format.replace(/be/g, 'yy');
				
				//============================
				
				//============================
				
				var bepattern = /25[0-9]{2}/g;
				if((value !== undefined) && (value !== null) && (value.match(bepattern))){
					var beyear = bepattern.exec(value)[0];
					var ceyear = beyear - 543;
					
					value = value.replace(new RegExp(beyear,"g"), ceyear);
				}
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
		
		'_showDatepicker': function(input){
			d__showDatepicker.apply(this, arguments);
			
			input = input.target || input;
			if (input.nodeName.toLowerCase() !== "input") { // find from button/image trigger
				input = $("input", input.parentNode)[0];
			}
			
			var inst = $.datepicker._getInst(input);
			
			var dateFormat = $.datepicker._get(inst, "dateFormat");
			if((dateFormat !== undefined) && (dateFormat !== null) && (dateFormat.match(/be/g))){
				var $uiyear = $('.ui-datepicker-year:not(.ui-datepicker-ext-be25xxpattern-yearbe)', inst.dpDiv);
				
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
					$this.addClass('ui-datepicker-ext-be25xxpattern-yearbe');
				});
			}
		}
	});
})(jQuery);