resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.project}/db_password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_secretsmanager_secret" "crypt_key" {
  name                    = "${var.project}/crypt_key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "crypt_key" {
  secret_id     = aws_secretsmanager_secret.crypt_key.id
  secret_string = var.magento_crypt_key
}
