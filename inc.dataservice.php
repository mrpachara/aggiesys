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

		abstract protected function getEntity($id, $where);

		public function get($id = null){
			$where = static::getWhere();

			$where['sqls'][] = '("id" = :id)';
			$where['params'][':id'] = $id;

			$data = $this->getEntity($id, $where);

			static::extendAction($data);

			return $data;
		}

		abstract public function getAll($termText = null, &$page = null);

		public function getAll($termText = null, &$page = null){
			$pageData = array(
				  'current' => null
				, 'previous' => null
				, 'next' => null
				, 'total' => null
			);

			$where = static::getWhere();

			$whereSearchTerm = static::getWhereSearchTerm(
				  array(
					  'username'
					, 'fullname'
					, 'userrole.role'
				)
				, static::getSearchTerm($termText)
			);


			$sqls = array_merge(
				  $where['sqls']
				, $whereSearchTerm['sqls']
			);

			$params = array_merge(
				  $where['params']
				, $whereSearchTerm['params']
			);

			$itemLimit = null;
			$limit = static::getLimit($page, $itemLimit);

			$sqlPattern = '
				SELECT DISTINCT
					  "user"."id" AS "id"
					, "user"."username" AS "username"
					, "user"."fullname" AS "fullname"
				FROM "user" LEFT JOIN "userrole" ON("user"."id" = "userrole"."id_user")
				'.((!empty($where['sqls']))? 'WHERE '.implode(' AND ', $sqls) : '').'
				%s
			';

			if(!empty($page)){
				$stmt = $this->getPdo()->prepare(sprintf('
					SELECT count("_realdata".*) AS "numrows" FROM (%s) AS "_realdata";
				', sprintf($sqlPattern, '')));
				$stmt->execute($params);
				$pageData['total'] = ceil($stmt->fetchColumn() / $itemLimit);
			}

			$stmt = $this->getPdo()->prepare(sprintf($sqlPattern.';', 'ORDER BY "username" ASC '.$limit));
			$stmt->execute($params);

			$users = $stmt->fetchAll(\PDO::FETCH_ASSOC);

			if(!empty($page)){
				$pageData['current'] = $page;
			}

			if(!empty($page) && ($page > 1)){
				$pageData['previous'] = $page - 1;
			}

			if(!empty($page) && ($page < $pageData['total'])){
				$pageData['next'] = $page + 1;
			}

			foreach($users as &$user){
				if(!empty($user['id'])){
					$user['roles'] = $this->getRoles($user['id']);

					static::extendAction($user);
				}
			}

			if(!empty($page)) $page = $pageData;

			return $users;
		}

		abstract public function save($id, &$data);
		abstract public function delete($id);
	}
?>
