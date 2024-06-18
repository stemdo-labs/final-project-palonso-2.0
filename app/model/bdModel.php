<?php
    class bd{
        protected $bbdd = "concierto";    
        protected $username = "pilar";
        protected $password = "pilar";
        protected $conexion;
 
        public function __construct(){
            $this->conexion = new PDO('mysql:host=10.0.2.4;dbname='.$this->bbdd, $this->username, $this->password);
        }
    }
?>