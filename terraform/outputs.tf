output "alb_url" {
  description = "Magento store URL"
  value       = "http://${aws_lb.main.dns_name}"
}

output "phpfpm_ecr_url" {
  value = aws_ecr_repository.phpfpm.repository_url
}

output "nginx_ecr_url" {
  value = aws_ecr_repository.nginx.repository_url
}

output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "opensearch_endpoint" {
  value = aws_opensearch_domain.main.endpoint
}

output "media_bucket" {
  value = aws_s3_bucket.media.bucket
}
