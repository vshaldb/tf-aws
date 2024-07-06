terraform {
  backend "s3" {
    bucket = "tfaws"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
  }
}