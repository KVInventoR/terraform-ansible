variable "DEFAULT_PROFILE" {
  description = "Default aws profile"
}

variable "AWS_REGION" {
  description = "Define default region for our template"
}

variable "INSTANCE_TYPE" {
  description = "Define instance type for EC2"
  default = "t2.micro"
}

variable "PATH_TO_PRIVATE_KEY" {
  description = "SSH private key for EC2"
}

variable "PATH_TO_PUBLIC_KEY" {
  description = "SSH public key for EC2"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "ROUTE53_ZONE" {
  description = "Default hosted zone"
}

variable "CLOUDTRAIL_IS_MULTI_REGION" {
  description = "Configure Cloudtrail"
  default = false
}

# Include events from global services such as IAM
variable "CLOUDTRAIL_INCLUDE_GLOBAL_SERVICE_EVENTS" {
  default = "true"
}

variable "INSTANCE_DEVICE_NAME" {
  description = "Attach EBS volume"
}

variable "DEFAULT_EBS_SIZE" {
  description = "Size of root volume for Jenkins EC2"
  default = "8"
}

variable "ADDITIONAL_EBS_SIZE" {
  description = "EBS volume size"
  default = "50"
}

variable "NOTIFICATION_ENDPOINT" {
  description = "SNS email"
}

variable "SSH_IP_ACL" {
  type = "list"
  description = "Access IPs. Need access for EC2 and ELB"
}

variable "SSL_CERT_FOR_ELB" {
  description = "ARN of the cert in ACM"
}

variable "ANSIBLE_INVENTORY_DIR" {
  type = "string"
  description = "Dir for Ansible inventory files"
}

variable "ANSIBLE_INVENTORY_NAME" {
  type = "string"
  description = "inventory file name"
}

variable "ANSIBLE_PYTHON_PATH" {
  type = "string"
  description = "Path for Ansible on target instance"
}
