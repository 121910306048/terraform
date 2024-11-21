resource "aws_s3_bucket" "manjubucket" {
  bucket = "manjuuuuuunadh"
}
resource "aws_dynamodb_table" "db" {
  name           = "terraform-state-lock-dynamodb"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }

}