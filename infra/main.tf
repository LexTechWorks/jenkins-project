terraform {
  backend "s3" {
    bucket = "lextechworks"
    key    = "project-z/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "app" {
  name         = "flask-jenkins-demo"
  force_delete = true
}

resource "aws_ecs_cluster" "main" {
  name = "project-z"
}
