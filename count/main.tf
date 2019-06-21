# Specify the provider and access details
resource "aws_elb" "web" {
  name = "terraform-example-elb"

  # The same availability zone as our instances
  # availability_zones = aws_instance.web.*.availability_zone
  availability_zones = ["us-east-2a", "us-east-2b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # The instances are registered automatically
  # instances = aws_instance.web.*.id
  instances = [google_compute_instance.vm_instance.id]
}

# resource "aws_instance" "web" {
#   instance_type = "t2.micro"
#   ami = var.aws_amis[var.aws_region]

#   # This will create 4 instances
#   count = 4
# }

resource "google_compute_instance" "vm_instance" {
	name = "terraform-instance"
	machine_type = "f1-micro"

	boot_disk {
		initialize_params {
    		image = "debian-cloud/debian-9"
		}
	}

	network_interface {
		# A default network is created for all GCP projects
		network       = "default"
		access_config {}
	}
}
