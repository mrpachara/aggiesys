<?php
	if(!defined("BASEPATH")){
		header("HTTP/1.1 404 Not Found");
		exit;
	}
	
	$_user = authen_getUser();
?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
		<meta charset="UTF-8" />
		<title>Lotto Web</title>
		
		<link rel="stylesheet" type="text/css" href="css/style.css" />
		
		<script type="text/javascript" src="js/jquery-2.0.3.js"></script>
	</head>
	<body id="layout-container" class="layout">
		<div id="layout-header" class="layout">
			<ul class="layout" style="float: left;">
				<li<?= (!isset($_menu) || ($_menu == "HOME"))? ' class="active"' : '' ?>><a href="main.php">Home</a></li>
<?php if(authoz_grant('MANAGER')): ?>
				<li<?= ($_menu == "ROUND")? ' class="active"' : '' ?>><a href="roundList.php">งวดการออกเลข</a></li>
				<li<?= ($_menu == "TRANSFER")? ' class="active"' : '' ?>><a href="transferList.php">การตัดยอด</a></li>
				<li<?= ($_menu == "DATA")? ' class="active"' : '' ?>><a href="dataList.php">ข้อมูล</a></li>
				<li<?= ($_menu == "ETC")? ' class="active"' : '' ?>><a href="etcInfo.php">ข้อมูลอื่นๆ</a></li>
<?php endif; ?>
<?php if(authoz_grant('ADMIN')): ?>
				<li<?= ($_menu == "USER")? ' class="active"' : '' ?>><a href="userList.php">ผู้ใช้งานระบบ</a></li>
<?php endif; ?>
			</ul>
			<ul class="layout" style="float: right;">
				<li style="font-weight: bold; color: red;"><?= htmlspecialchars($_user['fullname']) ?></li>
				<li><a id="cmd-logout" href="<?= htmlspecialchars($conf['page']['logout']) ?>">Logout</a></li>
			</ul>
		</div>
		<div>
<?= $_content ?>
		</div>
	</body>
</html>