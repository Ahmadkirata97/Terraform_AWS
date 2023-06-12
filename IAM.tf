provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "terraform_user" {
  
  name = "terraform_user"
  tags = {
    name = "terraform_user"
  }
}

resource "aws_iam_access_key" "terraform_access_key" {
  
  user = aws_iam_user.terraform_user.name
}

data "aws_iam_policy_document" "terraform_policy" { 

    statement {
        effect = "Allow"
        actions = ["ec2:Describe*"]
        resources = ["*"]
    }  
}

resource "aws_iam_user_policy" "terraform_user_policy" {
  
  name = "terraform_user_policy"
  user = aws_iam_user.terraform_user.name
  policy = data.aws_iam_policy_document.terraform_policy.json
}