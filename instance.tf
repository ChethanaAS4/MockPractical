resource "tls_private_key" "newkeys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "private_key_pem" {
  content  = tls_private_key.newkeys.private_key_pem
  filename = "${path.module}/mock-key.pem"
  file_permission = "0400"
}


resource "aws_key_pair" "key_pair" {
  key_name   = "mock-terraform-key"
  public_key = tls_private_key.newkeys.public_key_openssh
}


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
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  key_name      = aws_key_pair.key_pair.key_name

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
      private_key = tls_private_key.newkeys.private_key_pem
      host        = self.public_ip
    }
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.MockInstance.id
  domain   = "vpc"
}
