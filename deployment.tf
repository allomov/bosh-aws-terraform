resource "aws_instance" "jumpbox" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.jumpbox.key_name}"
    security_groups = [
        "${aws_security_group.ssh_only.id}"
    ]
    subnet_id = "${aws_subnet.vpc_public_subnet.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "${var.prefix}_jumpbox"
    }

    connection {
      type = "ssh"
      user = "${var.jumpbox_user}"
      private_key = "${file("${var.aws_private_key}")}"
      timeout = "5m"
    }

    provisioner "file" {
        source = "${var.aws_private_key}"
        destination = "/home/ubuntu/.ssh/id_rsa"
    }

    provisioner "file" {
        source = "${var.aws_public_key}"
        destination = "/home/ubuntu/.ssh/id_rsa.pub"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install software-properties-common -y",
            "sudo apt-add-repository ppa:ansible/ansible -y",
            "sudo apt-get update",
            "sudo apt-get install ansible=2.2.* -y",
            "sudo ansible-galaxy install allomov.bosh-jumpbox",
            "sudo ansible-playbook -i /etc/ansible/roles/allomov.bosh-jumpbox/examples/localhost/hosts /etc/ansible/roles/allomov.bosh-jumpbox/examples/localhost/playbook.yml"
        ]
    }


}

resource "aws_key_pair" "jumpbox" {
  key_name = "${var.prefix}_jumpbox_key"
  public_key = "${file("${var.aws_public_key}")}"
}
