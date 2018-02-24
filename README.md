## About

This repo contains automation code for deploying Jenkins to AWS in automated way

## General approach 
General approach for this code was to cover all initial requirements for a very limited time (1 day only)

So the approach was “not to re-invent the wheel” e.g. well-known Ansible roles were used as well as common box for Vagrant

Some actions are done manually because of security reasons and/or one-time nature, however they could be automated if necessary

## Toolset and current functionality
1. To be independent form local environment all provisioning runs from Vagrant machine which supports Parallels and VirtualBox hypervisors
2. Ubuntu is used as the most cloud-provider independent OS
3. Docker is used for application (Jenkins app in this case) independency from any OS
4. Terraform is used to orchestrate infrastructure components such as AWS VPC, EC2, EBS, etc.
5. Ansible is used to manage configuration for AWS EC2 instances
6. AWS CloudTrail is set to log all activities in AWS including events from global services such as AWS IAM
7. Custom VPC is used instead of the default one to make CI environment flexible and independent 
8. Custom VPC has private and public subnets which could be used for Jenkins agents on different purpose
9. Dedicated VPC Security Group are used to keep both EC2 and Application Load Balancer secure
10. Instead of creating key for SSH access on AWS side, custom SSH key is generated locally and uploaded to AWS
11. Application Load Balancer is used to add extra flexibility and security
12. Certificate Manager is used to provide and maintain SSL certificate used by Application Load Balancer
13. Finding the latest Ubuntu 16.04 AMI Instead of hardcoding particular AMI ID approach is used for extra security purpose
14. EC2 instance is used to host Docker container with running Jenkins
15. Dedicated EBS disk is connected to EC2 instance to keep important data even if EC2 instance was deleted with root EBS disk
16. Elastic Network Interface is used to have static local IP for Jenkins instance; this makes Jenkins agents reconnection in case of failure more reliable 
17. CloudWatch is used to collect important metrics from Application Load Balancer, EC2 and EBS
18. Route53 is used to maintain records in sub-domain used for this demo 
19. Vagrant machine can be executed on both Parallels and VirtualBox hypervisors 
20. Ansible is executing on developer’s machine only to keep target environment as clean as possible

## How-to reproduce
1. Register GitHub account if you don’t have it so far
2. Register AWS account if you don’t have it so far
3. Create AWS IAM user with security keys with admin permissions (restrict list of AWS services & region if it’s non-use AWS account)
4. Register new domain name or sub-domain to your existing domain in Route53 (could be explained in details on-demand)
5. Create wildcard SSL certificate in AWS Certificate Manager and confirm that request in Route53
6. Install Vagrant on your machine if you don’t have it so far
7. Clone this repo, open cloned repo’s location in Terminal
8. Run `vagrant up --provider virtualbox` if you're using VirtualBox
9. Run `vagrant ssh` to connect to the Vagrant box
10. Run `aws configure` to login to AWS CLI using AWS security keys created on step #3 and set default region e.g. *us-east-2* for Ohio
11. Run `cd /vagrant` to set location to the repo "root" which will be a workdir for the next steps
12. Run `mkdir ssh-keys && cd ssh-keys` than `ssh-keygen` to generate keys for SSH and than `cd ..` to get back to the workdir
13. Run `cp terraform.tfvars.sample terraform.tfvars` to get file to set variables
14. Fulfil `terraform.tfvars` with relevant values
15. Run `terraform init` to install necessary Terraform plugins
16. Run `terraform plan` to see resources which will be created
17. Run `terraform apply -auto-approve` to apply stack
18. Confirm SNS subscription which was sent to the email you specified in *terraform.tfvars*
19. Check terraform output and open link from `jenkins-dns_name` in your browser
20. Run `terraform destroy -force` to delete deployed resources 

## Further improvements
1. Set CloudWatch to watch suspicious activities in CloudTrail logs
2. Enable VPC flow logs and set CloudWatch for suspicious activities 
3. Deploy VPN service and move Jenkins to private subnet
4. Encrypt EBS disks with KMS keys, but not CMK
5. Move Jenkins workspace from EBS to centralised location e.g. S3 or NFS
6. Replace regular Jenkins instance with instance in Auto-Scaling group to replace instance automatically in case of failure
7. Develop advanced health-check script (executed in Lambda) that will check Jenkins status via Jenkins API
8. Develop Route53 health check and "sorry" landing page for outage times
9. Set CloudWatch to monitor OS (container) level metrics 
10. Set CloudWatch to monitor metrics specific for Jenkins 
11. Improve CloudWatch metrics based on data received during test period
12. Replace ‘bento/ubuntu-16.04’ Vagrant box with custom created with Packer
13. Install latest Terraform version instead of ‘0.11.3’ during Vagrant provisioning 
14. Fix security warnings reported by Jenkins
15. Add possibility to install particular Jenkins version
16. Implement Jenkins Single-sign on with GitHub
17. Replace forked Ansible roles with custom
18. Secure Jenkins password in Ansible role
19. Split Network and Jenkins to dedicated Terraform modules
20. Store Terraform state on Atlas 