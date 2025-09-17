resource "aws_ecs_task_definition" "app" {
  family                   = "flask-jenkins-demo"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions    = jsonencode([
    {
      name      = "flask-jenkins-demo"
      image     = aws_ecr_repository.app.repository_url
      essential = true
      portMappings = [
        {
          containerPort = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}
