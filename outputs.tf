output "web_dns_name" {
  value = "${aws_instance.web.public_dns}"
}

output "web_address" {
  value = "${aws_instance.web.public_ip}"
}
