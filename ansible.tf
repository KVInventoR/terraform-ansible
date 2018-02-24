resource "null_resource" "ansible-provision" {
  depends_on = ["aws_instance.ec2-jenkins"]

  triggers {
    key = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "echo \"[jenkins]\n${aws_instance.ec2-jenkins.public_dns} ansible_ssh_host=${aws_instance.ec2-jenkins.public_ip}\n\" > ansible/inventory/${var.ANSIBLE_INVENTORY_NAME}"
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
    "null_resource.ansible-provision",
  ]

  triggers {
    key = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "cd ansible && ansible-playbook -i inventory/${var.ANSIBLE_INVENTORY_NAME} -l jenkins --private-key=../${var.PATH_TO_PRIVATE_KEY} playbooks/jenkins.yml"
  }
}
