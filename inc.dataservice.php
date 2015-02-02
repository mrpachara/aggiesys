<?php
	namespace sys;

	abstract class DataService {
		const SEARCH_DELIMITER = "_:::_";
		private $pdo;

		protected static function getSearchTerm($termText){
			$searchTerm = array(
				  'terms' => array()
				, 'specials' => array()
			);

			if(empty($termText)) return $searchTerm;

			foreach(explode(' ', $termText) as $term){
				$termSplited = explode(':', $term, 2);

				if(count($termSplited) == 1){
					$searchTerm['terms'][] = $term;
				} else{
					if(!is_array($searchTerm['specials'][$termSplited[0]])) $searchTerm['specials'][$termSplited[0]] = array();

					$searchTerm['specials'][$termSplited[0]][] = $termSplited[1];
				}
			}

			return $searchTerm;
		}

		protected static function getWhere(){
			$where = array(
				  'sqls' => array()
				, 'params' => array()
			);

			return $where;
		}

		protected static function getWhereSearchTerm($allowedFields, $searchTerm){
			$where = array(
				  'sqls' => array()
				, 'params' => array()
			);

			if(empty($allowedFields) || empty($searchTerm['terms'])) return $where;

			foreach($allowedFields as &$allowedField){
				$allowedField = '"'.str_replace('.', '"."', $allowedField).'"';
			}

			$concatFn = "concat_ws('".static::SEARCH_DELIMITER."', ".implode(', ', $allowedFields).")";

			for($i = 0; $i < count($searchTerm['terms']); $i++){
				$term = $searchTerm['terms'][$i];
				$paramName = ":_term_".$i;
				$where['sqls'][] = "({$concatFn} ILIKE {$paramName})";
				$where['params'][$paramName] = "%{$term}%";
			}

			return $where;
		}

		protected static function getLimit(&$page = null, &$limit = null){
			global $conf;

			$limitSql = '';

			if(empty($page)) return $limitSql;

			$page = $page - 1;
			if($page < 0) $page = 0;
			$offset = $page * $conf['pagination']['numofitem'];
			$limit = ($limit === null)? $conf['pagination']['numofitem'] : $limit;

			$limitSql = "LIMIT {$limit} OFFSET {$offset}";

			$page = $page + 1;

			return $limitSql;
		}

		protected static function extendAction(&$data){
			if(empty($data)) return;

			$data['_updatable'] = true;
			$data['_deletable'] = true;
		}

		function __construct(){
			$this->pdo = new \sys\PDO();
		}

		protected function getPdo(){
			return $this->pdo;
		}

		abstract public function get($id = null);
		abstract public function getAll($termText = null, &$page = null);
		abstract public function save($id, &$data);
		abstract public function delete($id);
	}
?>
