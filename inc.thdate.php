<?php
	function thdate_year($year){
		if(empty($year)) return null;
		return ((strlen($year) == 4)? $year + 543 : $year + 43);
	}
	
	function thdate_mysql2th($tstamp, $isthmonth = false){
		if(empty($tstamp)) return null;
		
		$thmonth = array(
			   1 => "ม.ค."
			,  2 => "ก.พ."
			,  3 => "มี.ค."
			,  4 => "เม.ย."
			,  5 => "พ.ค."
			,  6 => "มิ.ย."
			,  7 => "ก.ค."
			,  8 => "ส.ค."
			,  9 => "ก.ย."
			, 10 => "ต.ค."
			, 11 => "พ.ย."
			, 12 => "ธ.ค."
		);
		
		$tstamps = explode(" ", $tstamp, 2);
		
		$dates = explode("-", $tstamps[0]);
		
		return $dates[2]."/".(($isthmonth)? $thmonth[(int)$dates[1]] : $dates[1])."/".thdate_year($dates[0]).(($tstamps[1] === null)? "" : " ".$tstamps[1]);
	}
?>