resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state-a3c6219"

  tags = {
    Name = "Terraform state"
  }
}

