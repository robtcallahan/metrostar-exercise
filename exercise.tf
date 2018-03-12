provider "aws" {
  region     = "${var.region}"
}

resource "aws_instance" "web" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  provisioner "file" {
    source      = "files/php.ini"
    destination = "/tmp/php.ini"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("~/.ssh/robs-mbp.pem")}"
    }
  }

  provisioner "file" {
    source      = "files/index.php"
    destination = "/tmp/index.php"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("~/.ssh/robs-mbp.pem")}"
    }
  }

  provisioner "file" {
    source      = "files/user_table.sql"
    destination = "/tmp/user_table.sql"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("~/.ssh/robs-mbp.pem")}"
    }
  }

  provisioner "file" {
    source      = "files/script.sh"
    destination = "/tmp/script.sh"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("~/.ssh/robs-mbp.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh ${var.db_user} ${var.db_pwd}"
    ]

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("~/.ssh/robs-mbp.pem")}"
    }
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.web.id}"
}

resource "aws_db_instance" "database" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.39"
  instance_class       = "db.t2.micro"
  name                 = "webdb"
  username             = "rob"
  password             = "dinx9one"
  parameter_group_name = "default.mysql5.6",
  skip_final_snapshot  = true
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}


