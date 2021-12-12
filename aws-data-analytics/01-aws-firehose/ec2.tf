variable "awsprops" {
    type = map
    default = {
    region = "ap-south-1"
    vpc = "vpc-5dbab435"
    ami = "ami-052cef05d01020f1d"
    itype = "t2.micro"
    subnet = "subnet-e4af988c"
    publicip = true
    keyname = "aws-rcp-test"
    secgroupname = "terraform_security_group"
  }
}

resource "aws_security_group" "project-iac-sg" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "admin-role"
  assume_role_policy = file("${path.module}/conf/assumeRoleEC2Policy.json")
}

resource "aws_iam_instance_profile" "admin_profile" {
  name  = "admin-profile"
  role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_iam_policy" "policy" {
  name        = "admin-policy"
  description = "Admin policy"
  policy      = file("${path.module}/conf/adminPolicy.json")
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_instance" "project-iac" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")
  iam_instance_profile = "${aws_iam_instance_profile.admin_profile.name}"
  user_data = file("${path.module}/conf/startup.sh")


  vpc_security_group_ids = [
    aws_security_group.project-iac-sg.id
  ]
  tags = {
    Name ="SERVER01"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.project-iac-sg ]
}

output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}