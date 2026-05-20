variable "aws_region" {
  default = "ap-southeast-1"
}

variable "aws_account_id" {
  default = "251917523920"
}

variable "project" {
  default = "magento"
}

variable "db_password" {
  sensitive   = true
  description = "MySQL password for the magento RDS user"
}

variable "magento_crypt_key" {
  sensitive   = true
  description = "Magento encryption key — copy from local app/etc/env.php crypt.key"
}

variable "opensearch_password" {
  default     = "Magento@Search1!"
  sensitive   = true
  description = "Master password for the OpenSearch internal user"
}
