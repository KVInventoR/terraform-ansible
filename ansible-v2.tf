resource "null_resource" "ansible-provision" {
  depends_on = ["aws_instance.ec2-jenkins"]

  triggers {
    key = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "echo \"[jenkins]\n${aws_instance.ec2-jenkins.public_dns} ansible_ssh_host=${aws_instance.ec2-jenkins.public_ip}\n\" > ansible/inventory/${var.ANSIBLE_INVENTORY_NAME}"
  }

  provisioner "local-exec" {
    command = "echo \"\n[openvpn]\" >> ansible/inventory/${var.ANSIBLE_INVENTORY_NAME}"
  }

  provisioner "local-exec" {
    command = "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s", aws_instance.ec2-openvpn.*.public_dns, aws_instance.ec2-openvpn.*.public_ip))}\" >> ansible/inventory/${var.ANSIBLE_INVENTORY_NAME}"
  }

  provisioner "local-exec" {
    command = "echo \"\n[all:vars]\" >> ansible/inventory/${var.ANSIBLE_INVENTORY_NAME}"
  }

  provisioner "local-exec" {
    command = "echo \"${format("ansible_ssh_user=%s", var.INSTANCE_USERNAME)}\" >> ansible/inventory/${var.ANSIBLE_INVENTORY_NAME}"
  }

  provisioner "local-exec" {
    command = "echo \"${format("ansible_python_interpreter=\"%s\"", var.ANSIBLE_PYTHON_PATH)}\" >> ansible/inventory/${var.ANSIBLE_INVENTORY_NAME}"
  }
}

resource "null_resource" "ec2-jenkins" {
  depends_on = [
    "aws_instance.ec2-jenkins",
    "aws_instance.ec2-openvpn",
    "null_resource.ansible-provision",
  ]

  triggers {
    key = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "cd ansible && ansible-playbook -i inventory/${var.ANSIBLE_INVENTORY_NAME} -l jenkins --private-key=../${var.PATH_TO_PRIVATE_KEY} playbooks/jenkins.yml"
  }

  provisioner "local-exec" {
    command = "cd ansible && ansible-playbook -i inventory/${var.ANSIBLE_INVENTORY_NAME} -l openvpn --private-key=../${var.PATH_TO_PRIVATE_KEY} playbooks/openvpn.yml"
  }
}
