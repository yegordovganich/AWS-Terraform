output "address" {
  # value = "Instances: ${element(aws_instance.web.*.id, 0)}"
  value = "Instances: ${aws_elb.web.id}"
}

