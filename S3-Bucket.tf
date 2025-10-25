resource "aws_s3_bucket" "bucket" {
  bucket = var.dennis_Domain
}

#Zugang öffentlich lassen
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#lesen erlauben
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.access]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Hauptwebsite deklarieren
resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "HelloWorld.html"
  }
}

#Html hochladen
resource "aws_s3_object" "webisteObjects" {
  for_each = fileset("Website/", "*")
  bucket = aws_s3_bucket.bucket.id
  key = each.value
  source = "Website/${each.value}"
  content_type = "text/html"

}
