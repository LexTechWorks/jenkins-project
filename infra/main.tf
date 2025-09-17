provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "app" {
  name = "flask-jenkins-demo"
}

resource "aws_ecs_cluster" "main" {
  name = "project-z"
}
