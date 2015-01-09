<?php
	function etchelper_getEtcproperties($mysqli){
		$etcproperties = array();
		
		$stmt = $mysqli->prepare("
			SELECT
				  *
			FROM
				`etc`
			ORDER BY
				`etc`.`listorder` ASC
		");
		
		$stmt->execute();
		$etcresult = $stmt->get_result();
		
		while($etc = $etcresult->fetch_assoc()){
			$etcproperties[$etc['code']] = $etc['value'];
		}
		
		return $etcproperties;
	}
?>