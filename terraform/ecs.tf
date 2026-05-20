resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/${var.project}"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project}-cluster"
  tags = { Name = "${var.project}-cluster" }
}

resource "aws_ecs_task_definition" "main" {
  family                   = var.project
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "${aws_ecr_repository.nginx.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 80, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "nginx"
        }
      }
    },
    {
      name      = "phpfpm"
      image     = "${aws_ecr_repository.phpfpm.repository_url}:latest"
      essential = true
      portMappings = [{ containerPort = 9000, protocol = "tcp" }]
      environment = [
        { name = "MAGE_MODE",                 value = "developer" },
        { name = "DB_HOST",                   value = aws_db_instance.main.address },
        { name = "DB_NAME",                   value = "magento" },
        { name = "DB_USER",                   value = "magento" },
        { name = "OPENSEARCH_HOST",           value = aws_opensearch_domain.main.endpoint },
        { name = "OPENSEARCH_USERNAME",       value = "magento" },
        { name = "OPENSEARCH_PASSWORD",       value = var.opensearch_password },
        { name = "MAGENTO_BACKEND_FRONTNAME", value = "admin_vaapxp1" },
        { name = "S3_MEDIA_BUCKET",           value = aws_s3_bucket.media.bucket },
        { name = "AWS_DEFAULT_REGION",        value = var.aws_region },
      ]
      secrets = [
        { name = "DB_PASSWORD",       valueFrom = aws_secretsmanager_secret.db_password.arn },
        { name = "MAGENTO_CRYPT_KEY", valueFrom = aws_secretsmanager_secret.crypt_key.arn },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "phpfpm"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = var.project
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}
