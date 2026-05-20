## Project Stack
- App: Magento 2.4.9 (Open Source) — installed via Mage-OS public mirror
- Local Custom Domain: http://magentoclaude.local
- Architecture: Decoupled 4-Container Microservices
  1. nginx:alpine (Port 80)
  2. php-fpm (PHP 8.3)
  3. mysql:8.0
  4. elasticsearch:7.17.18
- Infrastructure: Docker Compose (Local), AWS ECS Fargate & RDS (Production)
- CI/CD: GitHub Actions
- IaC: Terraform (not yet written — next session)

## Local Setup
- Magento files live in `src/` — bind-mounted into both nginx and php-fpm containers
- Search engine configured as `opensearch` (Magento 2.4.9 dropped elasticsearch7)
- MySQL network alias `db` used as the DB host
- Admin URL: http://magentoclaude.local/admin_vaapxp1
- Admin user: admin

## Custom Modules
- `Joby_Shipping` — flat-rate shipping carrier, price configurable via admin
  - Stores > Configuration > Sales > Delivery Methods > Joby Shipping

## GitHub
- Remote: https://github.com/jpdelacruz3/magento2026
- Branch: main
- Initial commit pushed — covers full Docker setup + Magento install + Joby_Shipping module

## Next Steps — AWS DevOps (Terraform + GitHub Actions)
The following needs to be built in the next session:

### Terraform (provision infrastructure once)
- ECR repository — stores built Docker images
- ECS Cluster + Fargate task definitions — runs nginx and php-fpm containers
- RDS MySQL 8.0 — managed database (replaces local mysql container)
- AWS OpenSearch Service — managed search (replaces local elasticsearch container)
- ALB (Application Load Balancer) — routes traffic to ECS
- S3 bucket — for pub/media uploads in production
- VPC, subnets, security groups, IAM roles

### GitHub Actions (runs on every git push to main)
- Build php-fpm Docker image
- Push image to ECR
- Update ECS task definition with new image
- Trigger ECS rolling deployment

### Credentials needed from user before starting
- AWS Access Key ID + Secret Access Key (IAM deploy user)
- AWS Region (e.g. ap-southeast-1)
- AWS Account ID (12-digit)
- Production domain name + SSL certificate ARN (ACM)
