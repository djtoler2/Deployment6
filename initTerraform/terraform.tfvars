#Provisioner
df_region               = "us-east-1"
default_region          = "us-east-1"
west_region             = "us-west-2"
# access_key              = "aws_access_key"
# secret_key              = "aws_secret_key"
#Network
df_cidr_block_anywhere      = "0.0.0.0/0"

vpc_cidr_block_east         = "10.0.0.0/16"
subnet_cidr_block_east_a    = "10.0.1.0/24"
subnet_cidr_block_east_b    = "10.0.2.0/24"
availability_zone_east_a    = "us-east-1a"
availability_zone_east_b    = "us-east-1b"

vpc_cidr_block_west         = "10.1.0.0/16"
subnet_cidr_block_west_a    = "10.1.1.0/24"
subnet_cidr_block_west_b    = "10.1.2.0/24"
availability_zone_west_a    = "us-west-2a"
availability_zone_west_b    = "us-west-2b"

public_ip                   = "true"

#Instance
ec2_ami_id              = "ami-0fc5d935ebf8bc3bc"
ec2_ami_id_east         = "ami-0fc5d935ebf8bc3bc"
ec2_ami_id_west         = "ami-0efcece6bed30fd98"
ec2_instance_type       = "t2.medium"
ec2_instance_tag_1      = {Name = "ec2_west_1"}
ec2_instance_tag_2      = {Name = "ec2_west_2"}
ec2_instance_tag_3      = {Name = "ec2_east_1"}
ec2_instance_tag_4      = {Name = "ec2_east_2"}
ud_app_dp6              = "ud_app_dp6.sh"
key_name                = "dp6_kp"
key_name_west           = "dp6_kp_west"

#Ports
ssh_access = {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

jenkins_access = {
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

http_access = {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

app_5000_access = {
  from_port   = 5000
  to_port     = 5000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

app_8000_access = {
  from_port   = 8000
  to_port     = 8000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

anywhere_outgoing = {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
