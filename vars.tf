variable "DEFAULT_PROFILE" {
  description = "Default aws profile"
}

variable "AWS_REGION" {
  description = "Define default region for our template"
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

variable "DEFAULT_ROUTE53_ZONE" {
  description = "Default hosted zone"
}

variable "CLOUDTRAIL_IS_MULTI_REGION" {
  description = "Configure Cloudtrail"
  default     = true
}

# Include events from global services such as IAM
variable "CLOUDTRAIL_INCLUDE_GLOBAL_SERVICE_EVENTS" {
  default = "true"
}

variable "INSTANCE_DEVICE_NAME" {
  description = "Attach EBS volume"
}

variable "DEFAULT_EC2_SIZE" {
  description = "Size of root volume for Jenkins EC2"
  default     = "8"
}

variable "EBS_VOLUME_SIZE" {
  description = "EBS volume size"
  default     = "50"
}

variable "NOTIFICATION_ENDPOINT" {
  description = "SNS email"
}

variable "SECURITY_GROUP_ACCESS" {
  type        = "list"
  description = "Access IPs. Need access for EC2 and ELB"
}
