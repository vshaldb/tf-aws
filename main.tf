resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_s3_bucket_object" "public_key" {
  bucket = var.s3_bucket
  key    = "ssh-keys/tfaws.pem"
  content = tls_private_key.ssh_key.private_key_pem

  depends_on = [
    tls_private_key.ssh_key
  ]
}

resource "aws_key_pair" "keypair" {
  key_name   = var.key_pair
  public_key = tls_private_key.ssh_key.public_key_openssh

  depends_on = [
    tls_private_key.ssh_key
  ]
}
resource "aws_network_interface" "nic" {
  subnet_id   = data.aws_subnet.subnet.id
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.keypair.key_name

  network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
  }

  tags = {
    Name = "tf-vm"
  }

  depends_on = [
    aws_key_pair.keypair
  ]
}