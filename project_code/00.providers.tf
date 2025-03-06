provider "aws" {
  region = "ap-northeast-2"  # 서울 리전
  alias  = "seoul"
}

provider "aws" {
  region = "us-east-1"       # 버지니아 리전
  alias  = "virginia"
}
