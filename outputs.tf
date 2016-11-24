output "jumpbox_ip" {
  value = "${aws_instance.jumpbox.public_ip}"
}


output "access_key_id" {
  value = "${var.aws_access_key}"
}

output "secret_access_key" {
  value = "${var.aws_secret_key}"
}

output "region" { value = "${var.aws_region}" }
output "az" { value = "${var.aws_az}" }

output "default_key_name" { value = "${var.aws_az}" }
output "az" { value = "${var.aws_az}" }

# output "default_key_name" {
# 	bosh_key_name
# }

# output "default_security_groups" {
#   value = "${var.aws_secret_key}"
# }

# output "subnet_id" {
# 	value =subnet-... \
# }

# output "director_name=$(dirname $PWD) \
# output "internal_cidr=10.10.0.0/24 \
# output "internal_gw=10.10.0.1 \
# output "internal_ip=10.10.0.6 \
# output "private_key=...output "