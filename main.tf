resource "aws_network_interface" "nic" {
  subnet_id   = data.aws_subnet.selected.id
  private_ips = ["172.31.0.1"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
  }

  tags = {
    Name = "tf-vm"
  }
}