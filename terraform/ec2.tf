resource "aws_instance" "app_server" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
    subnet_id = aws_subnet.public.id
   
    associate_public_ip_address = true
    
    tags = {
      Name = "Terraform-EC2-Docker"
    }
  
} 
resource "aws_security_group" "sg_ec2" {
  vpc_id = aws_vpc.main.id
  
  ingress {
    description = "HTTP from anywhere"
    protocol = "tcp"
    to_port = 80
    from_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    description = "Output can be anywhere"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}