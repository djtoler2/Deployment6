#Set variables for provisioner
variable "df_region"                {}
variable "default_region"           {}
variable "west_region"              {}
# variable "access_key"               {}
# variable "secret_key"               {}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

#Set variables for networking
variable "df_cidr_block_anywhere"   {}
variable "public_ip"                {}

variable "vpc_cidr_block_east"      {}            
variable "subnet_cidr_block_east_a" {}
variable "subnet_cidr_block_east_b" {}
variable "availability_zone_east_a" {}
variable "availability_zone_east_b" {}

variable "vpc_cidr_block_west"      {}
variable "subnet_cidr_block_west_a" {}
variable "subnet_cidr_block_west_b" {}
variable "availability_zone_west_a" {}
variable "availability_zone_west_b" {}

#Set variables for instances
variable "ec2_ami_id"               {}
variable "ec2_ami_id_east"          {}
variable "ec2_ami_id_west"          {}
variable "ec2_instance_type"        {}
variable "key_name"                 {}
variable "key_name_west"            {}

#Set IAM role for instances
variable "access_level"             {default = "ec2_full_access_role"}
variable "ver"                      {default = "2012-10-17"}
variable "action"                   {default = "sts:AssumeRole"}
variable "effect"                   {default = "Allow"}
variable "principal_service"        {default = "ec2.amazonaws.com"}
variable "policy_arn"               {default = "arn:aws:iam::aws:policy/AdministratorAccess"}
variable "instance_profile_name"    {default = "ec2_full_access_profile"}
variable "machine_role"             {default = "dp6_machine_role"}

#Set variables for instance tags
variable "ec2_instance_tag_1" {
  description = "tag for first instance"
  type        = map(string)
}

variable "ec2_instance_tag_2" {
  description = "tag for second instance"
  type        = map(string)
}

variable "ec2_instance_tag_3" {
  description = "tag for third instance"
  type        = map(string)
}

variable "ec2_instance_tag_4" {
  description = "tag for fourth instance"
  type        = map(string)
}


#Set variable for user data scripts
variable "ud_app_dp6" {
  description = "path to ud_app_dp6"
  default     = "ud_app_dp6.sh"
}

variable "ud_py_java" {
  description = "path to python script"
  default     = "user_data_5.1_java_python.sh"
}

#Set variables for ingress (incoming) traffic
variable "ssh_access" {
  description = "access through SSH on PORT 22"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "http_access" {
  description = "access through http on PORT 8000"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "jenkins_access" {
  description = "access jenkins on PORT 8080"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "app_8000_access" {
  description = "access app on 8000"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "app_5000_access" {
  description = "access app on 5000"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Set variables for egress(outgoing) traffic
variable "anywhere_outgoing" {
  description = "go anywhere outbound with any protocol"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 0
    to_port     = 65000
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

