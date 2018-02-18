resource "aws_key_pair" "key-jenkins" {
  key_name   = "key-jenkins"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

# Get the latest Ubuntu Xenial AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2-jenkins" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.key-jenkins.key_name}"
  subnet_id              = "${aws_subnet.main-public-1.id }"
  vpc_security_group_ids = ["${aws_security_group.ec2-securitygroup.id}"]

  root_block_device {
    volume_size           = "${var.DEFAULT_EC2_SIZE}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get install tmux mc -y",
    ]
  }

  connection {
    user        = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}

resource "ansible_host" "ec2-jenkins" {
  depends_on         = ["aws_instance.ec2-jenkins"]
  inventory_hostname = "${aws_instance.ec2-jenkins.public_dns}"
  groups             = ["jenkins"]

  vars {
    environment = "dev"
  }
}

# resource "null_resource" "ec2-jenkins" {
#   depends_on = ["ansible_host.ec2-jenkins"]

#   triggers {
#     key = "${uuid()}"
#   }

#   provisioner "local-exec" {
#     command = "cd ansible && TF_STATE='../terraform.tfstate' ansible-playbook -u ubuntu -e 'ansible_python_interpreter=/usr/bin/python3' -i terraform.py --private-key=../keys/jenkins playbooks/jenkins.yml"
#   }
# }

# TF_STATE="../terraform.tfstate" ansible --private-key=../keys/jenkins -u ec2-user -i terraform.py -m ping all

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = "${var.AWS_REGION}a"
  size              = "${var.EBS_VOLUME_SIZE}"
  type              = "gp2"

  tags {
    Name = "extra volume data"
  }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name  = "${var.INSTANCE_DEVICE_NAME}"
  volume_id    = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id  = "${aws_instance.ec2-jenkins.id}"
  skip_destroy = true
}
