resource "aws_key_pair" "key" {
  key_name   = "aws-key"
  public_key = var.aws_pub_key
}

resource "aws_instance" "vm" {
  ami                         = "ami-0aa2b7722dc1b5612"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.subnet_id
  vpc_security_group_ids      = [data.terraform_remote_state.vpc.outputs.security_group_id]
  associate_public_ip_address = true

  provisioner "local-exec"{
    command = "echo ${self.public_ip} >> public_ip.txt"
  }

  provisioner "file" {
    content = "ami used: ${self.ami}"
    destination = "/tmp/public_ip.txt"
  }

  provisioner "file" {
    source = "./teste.txt"
    destination = "/tmp/exemplo.txt"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("./aws-key")
    host = self.public_ip

  provisioner "remote-exec" {
    inline = [
      "echo ami: ${self.ami} >> /tmp/ami.txt",
      "echo private_ip: ${self.private_ip} >> /tmp/private_ip.txt"
    ]
  }
  }
  tags = {
    Name = "vm-terraform"
  }
}
