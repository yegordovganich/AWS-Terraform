provider "google" {
	credentials = "${file("secrets.json")}"
	project = "first-terraform-sample-project"
	region = "us-central1"
	zone = "us-central1-c"
}