data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "MockInstance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  subnet_id = aws_subnet.public-subnet-1.id
  key_name      = "Mockkey"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  tags = {
    Name = "MockInstance"
  }
provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:/Users/bubbl/Videos/Mockkey.pem")
      host        = self.public_ip
    }
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.MockInstance.id
  domain   = "vpc"
}
