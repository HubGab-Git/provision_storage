resource "aws_s3_bucket" "nebo" {
  bucket              = "nebo-bucket"
}

resource "aws_s3_bucket" "nebo_replication" {
  provider = aws.central
  bucket   = "nebo-bucket-replication"
}

# Enabled Blocking Public Access to S3 bucket
resource "aws_s3_bucket_public_access_block" "nebo" {
  bucket = aws_s3_bucket.nebo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "nebo_replication" {
  provider = aws.central
  bucket = aws_s3_bucket.nebo_replication.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enabled Encryption on bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "nebo" {
  bucket = aws_s3_bucket.nebo.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "nebo" {
  bucket = aws_s3_bucket.nebo.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "nebo_replication" {
  provider = aws.central
  bucket = aws_s3_bucket.nebo_replication.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.nebo]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.nebo.id

  rule {
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.nebo_replication.arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_access_point" "nebo" {
  bucket = aws_s3_bucket.nebo.id
  name   = "nebo"
}