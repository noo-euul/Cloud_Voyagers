#서울 보안그룹
resource "aws_security_group" "seoul_sg" {
  provider = aws.seoul
  vpc_id   = aws_vpc.CV_seoul_vpc.id
  name     = "CV_SG_seoul"

  ingress {#SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {#HTTP
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {#HTTPS
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "CV_SG_seoul"
  }
}
#버지니아
resource "aws_security_group" "virginia_sg" {
  provider = aws.virginia
  vpc_id   = aws_vpc.CV_virginia_vpc.id
  name     = "CV_SG_virginia"

  ingress {#SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  ingress {#HTTP
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {#HTTPS
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "CV_SG_virginia"
  }
}
