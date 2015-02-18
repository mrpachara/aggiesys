<!DOCTYPE html>
<html lang="th" xml:lang="th" xmlns="http://www.w3.org/1999/xhtml" ng-app="Aggiesys" layout="column">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<meta charset="UTF-8" />
		<meta http-equiv="Content-Language" content="en_US, th_TH" />
		<title>2/2557 midterm</title>
	</head>
	<body>
		<select>
<?php for($i = 1; $i <= 1000; $i++): ?>
<?php 	if(!(($i % 3 == 0) || ($i % 5 == 0))): ?>
			<option value="<?php echo $i ?>"><?php echo $i ?></option>
<?php 	endif; ?>
<?php endfor; ?>
		</select>
	</body>
</html>
