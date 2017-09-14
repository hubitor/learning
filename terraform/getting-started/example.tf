provider "aws" {
  version    = "~> 0.1.4"
  region     = "${var.region}"
  profile    = "${var.aws_profile}"
}

resource "aws_instance" "example" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"
  tags {
    Name = "TF_GS_Example"
  }
  # This is a part of the getting started guide but is kind of pointless once you create the elastic IP.
  #provisioner "local-exec" {
  #  command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  #}
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}
