provider "aws" {
  region = "${var.aws_region}"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "allow_ssh_and_web"
  description = "Allow ssh and web inbound traffic"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  name        = "allow_mysql"
  description = "Allow Mysql inbound traffic"
  vpc_id      = "${var.vpc_id}"

  # Mysql access from the VPC
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}

resource "aws_db_instance" "database" {
  name                  = "webdb"
  allocated_storage     = 10
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "5.6.39"
  instance_class        = "db.t2.micro"
  username              = "rob"
  password              = "dinx9one"
  parameter_group_name  = "default.mysql5.6"
  skip_final_snapshot   = true
  vpc_security_group_ids  = ["${aws_security_group.rds.id}"]
  tags                  = [
    {
      "Name" = "webdb"
    }
  ]
}

resource "aws_instance" "web" {
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/robs-mbp.pem")}"
  }

  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "robs-mbp"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.default.name}"]

  provisioner "file" {
    source      = "files/php.ini"
    destination = "/tmp/php.ini"
  }

  provisioner "file" {
    source = "files/index.php"
    destination = "/tmp/index.php"
  }

  provisioner "file" {
    source = "files/user_table.sql"
    destination = "/tmp/user_table.sql"
  }

  provisioner "file" {
    source = "files/script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "file" {
    source = "share/robs-mbp.pem"
    destination = "/tmp/robs-mbp.pem"
  }

  provisioner "file" {
    source = "share/config"
    destination = "/tmp/config"
  }

  provisioner "file" {
    source = "share/credentials"
    destination = "/tmp/credentials"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh ${var.db_user} ${var.db_pwd}"
    ]
  }

  depends_on = ["aws_db_instance.database"]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.web.id}"
}
