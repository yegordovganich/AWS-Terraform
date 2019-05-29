resource "aws_emr_cluster" "emr_cluster" {
	name = "tf-intetics-big-data"
	release_label = "emr-5.16.0"
	applications = ["Hadoop", "Hive", "Mahout", "Pig", "Hue", "Tez", "Ganglia"]
	service_role = "${aws_iam_role.EMR_DefaultRole.id}"
	log_uri = "s3://${aws_s3_bucket.s3_bucket.bucket}/logs/"
	tags = {
		name = "EMR cluster created via Terraform"
	}

	ec2_attributes {
		instance_profile = "${aws_iam_instance_profile.emr_profile.id}"
		key_name = "${aws_key_pair.emr_key_pair.key_name}"
		subnet_id = "${aws_subnet.emr_subnet.id}"
		emr_managed_master_security_group = "${aws_security_group.emr_allow_all.id}"
		emr_managed_slave_security_group  = "${aws_security_group.emr_allow_all.id}"
	}

	master_instance_group {
		name = "EMR Master EC2"
		instance_type = "m4.large"
	}
	core_instance_group {
		name = "EMR Core EC2"
		instance_type = "m4.large"
		instance_count = 2
	}

	step {
		name = "Hive program"
		action_on_failure = "CONTINUE"
		hadoop_jar_step {
			jar = "command-runner.jar"
			args = [
				"hive-script",
				"--run-hive-script",
				"--args",
				"-f", "s3://us-east-2.elasticmapreduce.samples/cloudfront/code/Hive_CloudFront.q",
				"-d", "INPUT=s3://us-east-2.elasticmapreduce.samples",
				"-d", "OUTPUT=s3://${aws_s3_bucket.s3_bucket.bucket}/output/"
			]
		}
	}
}

resource "aws_iam_instance_profile" "emr_profile" {
  name  = "emr_profile"
  role = "${aws_iam_role.EMR_EC2_DefaultRole.id}"
}
