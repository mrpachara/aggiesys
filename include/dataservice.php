<?php
	namespace sys;

	class DataServiceException extends \Exception {

	}

	abstract class DataService {
		const SEARCH_DELIMITER = "_:::_";

		protected static function getSearchableFields(){
			return array();
		}

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
					if(empty($searchTerm['specials'][$termSplited[0]])) $searchTerm['specials'][$termSplited[0]] = array();

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

		protected static function getWhereSearchSpecial(&$searchTerm){
			$where = array(
				  'sqls' => array()
				, 'params' => array()
			);

			return $where;
		}

		protected static function getWhereSearchTerm(&$searchTerm){
			$where = array(
				  'sqls' => array()
				, 'params' => array()
			);

			$searchableFields = static::getSearchableFields();

			if(empty($searchableFields) || empty($searchTerm['terms'])) return $where;

			foreach($searchableFields as &$allowedField){
				$allowedField = '"'.str_replace('.', '"."', $allowedField).'"';
			}

			$concatFn = "concat_ws('".static::SEARCH_DELIMITER."', ".implode(', ', $searchableFields).")";

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

		private $pdo;

		function __construct(){
			$this->pdo = \sys\PDO::getInstance();
		}

		protected function getPdo(){
			return $this->pdo;
		}

		abstract protected function getEntity($id, $where);

		public function get($id = null){
			$where = static::getWhere();

			$where = array_merge_recursive(
				  array(
					  'sqls' => array('("id" = :_id)')
					, 'params' => array(':_id' => $id)
				), $where
			);

			$data = $this->getEntity($id, $where);

			static::extendAction($data);

			return $data;
		}

		public function getByCode($code = null){
			$where = static::getWhere();

			$where = array_merge_recursive(
				  array(
					  'sqls' => array('("code" = :_code)')
					, 'params' => array(':_code' => $code)
				), $where
			);

			$data = $this->getEntity(0, $where);

			static::extendAction($data);

			return $data;
		}

		abstract protected function getAllEntity($where, $limit, &$pageData);

		public function getAll($termText = null, &$page = null){
			$pageData = array(
				  'current' => $page
				, 'previous' => null
				, 'next' => null
				, 'total' => null
				, 'limit' => null
			);

			$where = static::getWhere();

			$searchTerm = static::getSearchTerm($termText);
			$whereSearchSpecial = static::getWhereSearchSpecial($searchTerm);
			$whereSearchTerm = static::getWhereSearchTerm($searchTerm);

			$where = array_merge_recursive($where, $whereSearchSpecial, $whereSearchTerm);

			$datas = $this->getAllEntity($where, static::getLimit($pageData['current'], $pageData['limit']), $pageData);

			if(!empty($pageData['current'])) $page = $pageData;

			return $datas;
		}

		abstract protected function saveEntity($id, &$data);

		public function save($id, &$data){
			if(empty($data)){
				throw new \sys\DataServiceException("update %s{$id} without data", 400);
			}

			$existedData = $this->get($id);

			if($existedData === false){
				throw new \sys\DataServiceException("%s{$id} not found", 404);
			}

			if(!$existedData['_updatable']){
				throw new \sys\DataServiceException("%s{$id} cannot be updated", 500);
			}

			$id = $existedData['id'];

			$this->getPdo()->beginTransaction();

			try{
				$id = $this->saveEntity($id, $data);
			} catch(\PDOException $excp){
				$this->getPdo()->rollBack();
				throw $excp;
			}

			return ($this->getPdo()->commit())? $id : false;
		}

		abstract protected function deleteEntity($id);

		public function delete($id){
			if(empty($id)){
				throw new \sys\DataServiceException("unknown id to delete %s", 400);
			}

			$existedData = $this->get($id);

			if($existedData === false){
				throw new \sys\DataServiceException("%s{$id} not found", 404);
			}

			if(!$existedData['_deletable']){
				throw new \sys\DataServiceException("%s{$id} cannot be deleted", 500);
			}

			$id = $existedData['id'];

			$this->getPdo()->beginTransaction();

			try{
				$id = $this->deleteEntity($id);
			} catch(\PDOException $excp){
				$this->getPdo()->rollBack();
				throw $excp;
			}

			return ($this->getPdo()->commit())? $id : false;
		}
	}
?>
