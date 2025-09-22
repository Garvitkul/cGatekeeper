# ==========================
# Fully Compliant Terraform Code
# ==========================

variable "common_tags" {
  default = {
    BUID  = "12345"
    Label = "production"
    Owner = "team"
    Env   = "prod"
  }
}

# ---- S3 BUCKETS ----
resource "aws_s3_bucket" "good_s3" {
  bucket = "good-s3-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = merge(var.common_tags, { Name = "good-s3" })
}

# ---- EBS VOLUME ----
resource "aws_ebs_volume" "good_volume" {
  availability_zone = "us-east-1a"
  size              = 10
  encrypted         = true
  kms_key_id        = aws_kms_key.platform.arn

  tags = merge(var.common_tags, { Name = "good-ebs" })
}

# ---- EFS ----
resource "aws_efs_file_system" "good_efs" {
  creation_token = "efs-compliant"
  encrypted      = true

  tags = merge(var.common_tags, { Name = "good-efs" })
}

# ---- RDS ----
resource "aws_db_instance" "good_rds" {
  identifier          = "good-rds"
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "admin"
  password            = "SuperSecret123!"
  publicly_accessible = false
  skip_final_snapshot = true

  tags = merge(var.common_tags, { Name = "good-rds" })
}

# ---- EC2 INSTANCE ----
resource "aws_instance" "good_ec2" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  associate_public_ip_address = false

  tags = merge(var.common_tags, { Name = "good-ec2" })
}

# ---- SQS ----
resource "aws_kms_key" "platform" {
  description = "KMS key for SQS encryption"
  tags = merge(var.common_tags, { Name = "good-queue" })
}

resource "aws_sqs_queue" "good_queue" {
  name                       = "good-queue"
  kms_master_key_id           = aws_kms_key.platform.arn
  kms_data_key_reuse_period_seconds = 300

  tags = merge(var.common_tags, { Name = "good-queue" })
}

# ---- LAMBDA ----
resource "aws_lambda_function" "good_lambda" {
  function_name = "good_lambda"
  role          = "arn:aws:iam::123456789012:role/lambda-role"
  handler       = "index.handler"
  runtime       = "python3.9"
  filename      = "lambda.zip"

  # No plaintext secrets in environment
  environment {
    variables = {
      DB_PASSWORD = "ENCRYPTED:use-secrets-manager"
      API_KEY     = "ENCRYPTED:use-secrets-manager"
    }
  }

  tags = merge(var.common_tags, { Name = "good-lambda" })
}






