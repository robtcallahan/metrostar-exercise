variable "region" {
  default = "us-east-1"
}

variable key_name {
  default = "robs-mbp"
}

variable "public_key_path" {
  description = "Path to ssh key"
  default = "~/.ssh/id_rsa.pub"
}

variable ami {
  default = "ami-97785bed" 
}

variable instance_type { 
  default = "t2.micro" 
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
