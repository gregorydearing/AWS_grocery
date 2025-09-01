resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate-avatars-eunorth1-gregdearing"
  acl    = "private"

  tags = {
    Name        = "grocerymate-avatars"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "avatars" {
  bucket = aws_s3_bucket.avatars.id
  versioning_configuration {
    status = "Enabled"
  }
}

