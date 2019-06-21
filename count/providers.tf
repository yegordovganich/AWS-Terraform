provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

provider "google" {
	credentials = "${file("secrets.json")}"
	project = "first-terraform-sample-project"
	region = "us-central1"
	zone = "us-central1-c"
}