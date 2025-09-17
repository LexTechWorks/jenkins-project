resource "aws_ecs_service" "app" {
  name            = "flask-jenkins-demo-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.app_sg.id]
    assign_public_ip = true
  }
  depends_on = [aws_ecs_task_definition.app]
}
