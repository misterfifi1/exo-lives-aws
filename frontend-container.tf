# container template
data "template_file" "frontend_app" {
  template = file("./frontend.json")
  vars = {
    app_name = var.frontend_app_name
    app_image = var.frontend_app_image
    app_port = var.frontend_app_port
    fargate_cpu = var.frontend_fargate_cpu
    fargate_memory = var.frontend_fargate_memory
    aws_region = var.aws_region
  }
}
# ECS task definition
resource "aws_ecs_task_definition" "frontend_app" {
  family = "frontend-task"
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.frontend_fargate_cpu
  memory = var.frontend_fargate_memory
  container_definitions = data.template_file.frontend_app.rendered
  
}
# ECS service
resource "aws_ecs_service" "frontend_app" {
  name = var.frontend_app_name
  cluster = aws_ecs_cluster.aws-ecs.id
  task_definition = aws_ecs_task_definition.frontend_app.arn
  desired_count = var.frontend_app_count
  launch_type = "FARGATE"
  network_configuration {
    subnets = aws_subnet.aws-subnet.*.id
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.frontend_app.id
    container_name = var.frontend_app_name
    container_port = var.frontend_app_port
  }
  depends_on = [aws_alb_listener.front_end]
}
variable "frontend_app_name" {
  description = "Name of Application Container"
  default = "livestorm-fe"
}
variable "frontend_app_image" {
  description = "Docker image to run in the ECS cluster"
  default = "misterfifi/exo-hello-live:latest"
}
variable "frontend_app_port" {
  description = "Port exposed by the Docker image to redirect traffic to"
  default = 80
}
variable "frontend_app_count" {
  description = "Number of Docker containers to run"
  default = 1
}
variable "frontend_fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default = "256"
}
variable "frontend_fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default = "512"
}