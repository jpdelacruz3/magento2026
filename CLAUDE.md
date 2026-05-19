## Project Stack
- App: Magento 2.4.x (Latest Open Source)
- Local Custom Domain: http://magentoclaude.local
- Architecture: Decoupled 4-Container Microservices
  1. nginx:alpine (Port 80)
  2. php-fpm (PHP 8.2 or 8.3)
  3. mysql:8.0
  4. elasticsearch:7.17
- Infrastructure: Docker Compose (Local), AWS ECS Fargate & RDS (Production)
- CI/CD: GitHub Actions