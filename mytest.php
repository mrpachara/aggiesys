<?php
	error_reporting(E_ALL);
	ini_set('display_errors', 1);

	class A {
		protected static function getHelloWord(){
			return "from Class A";
		}

		function __construct(){

		}

		public function hello(){
			echo static::getHelloWord();
		}

		protected function getX(){
			return "protected form A";
		}

		public function hello2(){
			echo $this->getX();
		}
	}

	Class B extends A {
		protected static function getHelloWord(){
			return "from Class B";
		}

		function __construct(){

		}

		protected function getX(){
			return "protected form B";
		}

	}

	$a = new A();
	$b = new B();

	$a->hello()."<br />";
	$b->hello()."<br />";
	$a->hello2()."<br />";
	$b->hello2()."<br />";


	class TestException extends Exception{

	}

	throw new TestException("test exception", -1);
?>
