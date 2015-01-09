<?php
	function pagination($numofitem = null){
		global $conf;
		global $_tmpsess;
		global $_ntmpsess;
		
		$pagination = $conf['pagination'];
		
		if($numofitem === null) $numofitem = $pagination['numofitem'];
		parse_str($_SERVER['QUERY_STRING'], $qss); // don't use $_GET to prevent anti-magic_quotes
		if(empty($qss['page']) || ($qss['page'] < 1)){
			$url_path = parse_url($_SERVER['REQUEST_URI'],PHP_URL_PATH);
			$qss['page'] = 1;
			$newqs = http_build_query($qss);
			
			$_ntmpsess = $_tmpsess;
			
			header("Location: {$url_path}?{$newqs}");
			exit();
		}
		
		return array('page' => (int)$qss['page'],'offset' => ($qss['page'] - 1) * $numofitem, 'numofitem' => $numofitem);
	}
	
	function pagination_html($pagedata, $total = null){
		global $conf;
		$pagination = $conf['pagination'];
		
		$page = $pagedata;
		$numofitem = $pagination['numofitem'];
		
		if(is_array($pagedata)){
			$page = $pagedata['page'];
			$numofitem = $pagedata['numofitem'];
		}
		
		$html = "";
		
		$isHasPrevious = ($page > 1);
		$isHasNext = (is_bool($total))? $total : true;
		$navigationMode = 0;
		$maxPage = 0;
		
		if(is_int($total)){
			$navigationMode = 1;
			$maxPage = ceil($total/$numofitem);
			
			if($maxPage > $pagination['numofshowedpage']) $navigationMode = 2;
			if($page >= $maxPage) $isHasNext = false;
		}
		
		$url_path = parse_url($_SERVER['REQUEST_URI'],PHP_URL_PATH);
		parse_str($_SERVER['QUERY_STRING'], $qss); // prevent anti-magic_quote
		
		$qss['page'] = $page - 1;
		$pre_url = $url_path.'?'.http_build_query($qss, null, '&amp;');
		
		$qss['page'] = $page + 1;
		$next_url = $url_path.'?'.http_build_query($qss, null, '&amp;');
		
		ob_start();
?>
<span class="pagination_nav" style="white-space nowrap;">
<?php if($isHasPrevious): ?>
	<a href="<?= $pre_url ?>">&lt;&lt; <?= htmlspecialchars((!empty($pagination['previoustext']))? $pagination['previoustext'] : 'Previous') ?></a>
<?php else: ?>
	<label title="<?= htmlspecialchars((!empty($pagination['noprevioustext']))? $pagination['noprevioustext'] : 'This is a first page') ?>" style="opacity: 0.50;">&lt;&lt; <?= htmlspecialchars((!empty($pagination['previoustext']))? $pagination['previoustext'] : 'Previous') ?></label>
<?php endif; ?>
<?php for($i = 1; $i <= $maxPage; $i++): ?>
<?php 	$qss['page'] = $i; ?>
<?php 	if(($navigationMode == 2) && ($i == 1)): ?>
	<select onchange="window.location.href=this.value;" style="margin-left: 0.25em; margin-right: 0.25em;">
<?php 	endif; ?>
<?php 	if(($navigationMode == 1)): ?>
<?php 		if($page == $i): ?>
	<label title="<?= htmlspecialchars((!empty($pagination['currenttext']))? $pagination['currenttext'] : 'This is a current page') ?>" style="margin-left: 0.25em; margin-right: 0.25em;"><?= htmlspecialchars($i) ?></label>
<?php 		else: ?>
	<a href="<?= $url_path.'?'.http_build_query($qss, null, '&amp;') ?>" style="margin-left: 0.25em; margin-right: 0.25em;"><?= htmlspecialchars($i) ?></a>
<?php 		endif; ?>
<?php 	else: ?>
		<option value="<?= $url_path.'?'.http_build_query($qss, null, '&amp;') ?>" <?= ($page == $i)? ' selected="selected"' : '' ?>><?= htmlspecialchars($i) ?></option>
<?php 	endif; ?>
<?php 	if(($navigationMode == 2) && ($i == $maxPage)): ?>
	</select>
<?php 	endif; ?>
<?php endfor; ?>
<?php if($isHasNext): ?>
	<a href="<?= $next_url ?>"><?= htmlspecialchars((!empty($pagination['nexttext']))? $pagination['nexttext'] : 'Next') ?> &gt;&gt;</a>
<?php else: ?>
	<label title="<?= htmlspecialchars((!empty($pagination['nonexttext']))? $pagination['nonexttext'] : 'This is a last page') ?>" style="opacity: 0.50;"><?= htmlspecialchars((!empty($pagination['nexttext']))? $pagination['nexttext'] : 'Next') ?> &gt;&gt;</label>
<?php endif; ?>
</span>
<?php
		$html = ob_get_contents();
		ob_end_clean();
		
		return $html;
	}
?>