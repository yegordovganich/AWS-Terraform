resource "aws_subnet" "emr_subnet" {
	vpc_id = "${aws_vpc.emr_vpc.id}"
	cidr_block = "168.31.0.0/20"
	tags {
		Name = "EMR Subnet / Terraform"
	}
}

resource "aws_vpc" "emr_vpc" {
	cidr_block = "168.31.0.0/16"
	enable_dns_hostnames = true
	tags {
		Name = "EMR VPC / Terraform"
	}
}

resource "aws_route_table" "emr_rt" {
	vpc_id = "${aws_vpc.emr_vpc.id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.emr_gw.id}"
	}
	tags {
		Name = "EMR RT / Terraform"
	}
}

resource "aws_internet_gateway" "emr_gw" {
	vpc_id = "${aws_vpc.emr_vpc.id}"
	tags {
		Name = "EMR IG / Terraform"
	}
}

resource "aws_main_route_table_association" "emr_mrta" {
	vpc_id = "${aws_vpc.emr_vpc.id}"
	route_table_id = "${aws_route_table.emr_rt.id}"
}

resource "aws_security_group" "emr_allow_all" {
	name = "tf_emr_allow_all"
	description = "Allow all inbound traffic / Terraform"
	vpc_id = "${aws_vpc.emr_vpc.id}"
	depends_on = ["aws_subnet.emr_subnet"]
	tags {
		Name = "EMR SG / Terraform"
	}
	ingress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}
