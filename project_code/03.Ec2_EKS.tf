resource "aws_instance" "CV_seoul_ec2" {
  provider               = aws.seoul
  ami                    = "ami-0a2c043e56e9abcc5"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.seoul_sg.id]
  subnet_id              = aws_subnet.CV_public_seoul_a.id
  #키네임 본인꺼로 key_name               = "soldesk_keyK" #서울 키네임

  tags = {
    Name = "CV_seoul_ec2"
  }
}

resource "aws_instance" "CV_virginia_ec2" {
  provider    = aws.virginia
  ami         = "ami-0c614dee691cbbf37"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.virginia_sg.id]
  subnet_id   = aws_subnet.CV_public_virginia_a.id
  #키네임 본인꺼로 key_name    = "soldesk_keyV" #버지니아 키네임

  tags = {
    Name = "CV_virginia_ec2"
  }
}