variable "region" {
  default = "us-east-1"
}

variable ami { 
  default = "ami-97785bed" 
}

variable instance_type { 
  default = "t2.micro" 
}

variable key_name { 
  default = "robs-mbp" 
}

variable root_passwd {
  default = "dinx9one"
}

variable db_user { 
  default = "rob" 
}

variable db_pwd { 
  default = "dinx9one" 
}
