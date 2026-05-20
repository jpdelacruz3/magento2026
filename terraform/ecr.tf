resource "aws_ecr_repository" "phpfpm" {
  name                 = "${var.project}-phpfpm"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags                 = { Name = "${var.project}-phpfpm" }
}

resource "aws_ecr_repository" "nginx" {
  name                 = "${var.project}-nginx"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  tags                 = { Name = "${var.project}-nginx" }
}

resource "aws_ecr_lifecycle_policy" "phpfpm" {
  repository = aws_ecr_repository.phpfpm.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 5 }
      action       = { type = "expire" }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "nginx" {
  repository = aws_ecr_repository.nginx.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 5 }
      action       = { type = "expire" }
    }]
  })
}
