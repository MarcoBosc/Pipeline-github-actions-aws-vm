resource "aws_key_pair" "key" {
  key_name   = "aws-key"
  public_key = var.aws_pub_key
}

resource "aws_instance" "vm" {
  ami                         = "ami-0889a44b331db0194"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = "subnet-0c5c9205f1bba9214"
  vpc_security_group_ids      = ["sg-0962723ccb8b0a0e8"]
  associate_public_ip_address = true

  tags = {
    "Name" = "vm-terraform"
    "Managed-by" = "Terraform"
  }
}