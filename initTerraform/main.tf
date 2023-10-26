#https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep
#Providers *****************************************************************

provider "aws" {
  region     = var.default_region
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
}

provider "aws" {
  alias         = "east"
  region        = var.df_region
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
}

provider "aws" {
  alias         = "west"
  region        = var.west_region
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
}

#2 VPCS *******************************************************************************
resource "aws_vpc" "vpc_east" {
  provider = aws.east
  cidr_block   = var.vpc_cidr_block_east
  tags        = {Name = "VPC-us-east-1"}
}

  # Sleep for VPC East *************************************************
resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_vpc.vpc_east]

  create_duration = "30s"
}

resource "aws_vpc" "vpc_west" {
  provider = aws.west
  cidr_block = var.vpc_cidr_block_west   
  tags = {Name = "VPC-us-west-2"}
}

# Sleep for VPC West *************************************************
resource "time_sleep" "wait_30_seconds2" {
  depends_on = [aws_vpc.vpc_west]

  create_duration = "30s"
}



# 2 Subnets for us-east-1 *************************************************************
resource "aws_subnet" "subnet_1_east" {
  provider                = aws.east
  vpc_id                  = aws_vpc.vpc_east.id
  cidr_block              = var.subnet_cidr_block_east_a
  availability_zone       = var.availability_zone_east_a
  map_public_ip_on_launch = var.public_ip
}

resource "aws_subnet" "subnet_2_east" {
  provider                = aws.east
  vpc_id                  = aws_vpc.vpc_east.id
  cidr_block              = var.subnet_cidr_block_east_b
  availability_zone       = var.availability_zone_east_b
  map_public_ip_on_launch = var.public_ip
}

# Subnets for us-west-2 ***************************************************************
resource "aws_subnet" "subnet_1_west" {
  provider                = aws.west
  vpc_id                  = aws_vpc.vpc_west.id
  cidr_block              = var.subnet_cidr_block_west_a
  availability_zone       = var.availability_zone_west_a
  map_public_ip_on_launch = var.public_ip
}

resource "aws_subnet" "subnet_2_west" {
  provider                = aws.west
  vpc_id                  = aws_vpc.vpc_west.id
  cidr_block              = var.subnet_cidr_block_west_b
  availability_zone       = var.availability_zone_west_b
  map_public_ip_on_launch = var.public_ip
}


#Security Group for US West 2 **********************************************************
resource "aws_security_group" "dp6_sg_west" {
  provider = aws.west
  vpc_id = aws_vpc.vpc_west.id

  ingress {
    from_port   = var.ssh_access.from_port
    to_port     = var.ssh_access.to_port
    protocol    = var.ssh_access.protocol
    cidr_blocks = var.ssh_access.cidr_blocks
  }

  ingress {
    from_port   = var.app_8000_access.from_port
    to_port     = var.app_8000_access.to_port
    protocol    = var.app_8000_access.protocol
    cidr_blocks = var.app_8000_access.cidr_blocks
  }

  egress {
    from_port   = var.anywhere_outgoing.from_port
    to_port     = var.anywhere_outgoing.to_port
    protocol    = var.anywhere_outgoing.protocol
    cidr_blocks = var.anywhere_outgoing.cidr_blocks
  }
}

#Security Group for US East 1 *****************************************************
resource "aws_security_group" "dp6_sg_east" {
  provider      = aws.east
  vpc_id        = aws_vpc.vpc_east.id

  ingress {
    from_port   = var.ssh_access.from_port
    to_port     = var.ssh_access.to_port
    protocol    = var.ssh_access.protocol
    cidr_blocks = var.ssh_access.cidr_blocks
  }

  ingress {
    from_port   = var.app_8000_access.from_port
    to_port     = var.app_8000_access.to_port
    protocol    = var.app_8000_access.protocol
    cidr_blocks = var.app_8000_access.cidr_blocks
  }

  egress {
    from_port   = var.anywhere_outgoing.from_port
    to_port     = var.anywhere_outgoing.to_port
    protocol    = var.anywhere_outgoing.protocol
    cidr_blocks = var.anywhere_outgoing.cidr_blocks
  }
}


#EC2 Instances for US East 1 **************************************************************
resource "aws_instance" "applicationServer01-east" {
  ami                             = "ami-0fc5d935ebf8bc3bc"
  instance_type                   = var.ec2_instance_type
  subnet_id                       = aws_subnet.subnet_1_east.id
  vpc_security_group_ids          = [aws_security_group.dp6_sg_east.id]
  tags                            = var.ec2_instance_tag_3
  user_data                       = base64encode(file(var.ud_app_dp6))
  associate_public_ip_address     = var.public_ip
  key_name                        = var.key_name
  iam_instance_profile            = var.machine_role
}

resource "aws_instance" "applicationServer02-east" {
  ami                             = "ami-0fc5d935ebf8bc3bc"
  instance_type                   = var.ec2_instance_type
  subnet_id                       = aws_subnet.subnet_2_east.id
  vpc_security_group_ids          = [aws_security_group.dp6_sg_east.id]
  tags                            = var.ec2_instance_tag_4
  user_data                       = base64encode(file(var.ud_app_dp6))
  associate_public_ip_address     = var.public_ip
  key_name                        = var.key_name
  iam_instance_profile            = var.machine_role
}


#EC2 Instances for US West 2 ***********************************************************
resource "aws_instance" "applicationServer01-west" {
  provider                        = aws.west
  ami                             = "ami-0efcece6bed30fd98"
  instance_type                   = var.ec2_instance_type
  subnet_id                       = aws_subnet.subnet_1_west.id
  vpc_security_group_ids          = [aws_security_group.dp6_sg_west.id]
  tags                            = var.ec2_instance_tag_1
  user_data                       = base64encode(file(var.ud_app_dp6))
  associate_public_ip_address     = var.public_ip
  key_name                        = var.key_name_west
  iam_instance_profile            = var.machine_role
}

resource "aws_instance" "applicationServer02-west" {
  provider                        = aws.west
  ami                             = "ami-0efcece6bed30fd98"
  instance_type                   = var.ec2_instance_type
  subnet_id                       = aws_subnet.subnet_2_west.id
  vpc_security_group_ids          = [aws_security_group.dp6_sg_west.id]
  tags                            = var.ec2_instance_tag_2
  user_data                       = base64encode(file(var.ud_app_dp6))
  associate_public_ip_address     = var.public_ip
  key_name                        = var.key_name_west
  iam_instance_profile            = var.machine_role
}

# Internet Gateway for US West 2
resource "aws_internet_gateway" "dp6_igw_west" {
  provider = aws.west
  vpc_id = aws_vpc.vpc_west.id
}

# Internet Gateway for US East 1
resource "aws_internet_gateway" "dp6_igw_east" {
  provider = aws.east
  vpc_id = aws_vpc.vpc_east.id
}

# Route Table for Us West 2 **********************************************************
resource "aws_route_table" "main_west" {
  provider                  = aws.west
  vpc_id                    = aws_vpc.vpc_west.id

  route {
    cidr_block              = var.df_cidr_block_anywhere
    gateway_id              = aws_internet_gateway.dp6_igw_west.id
  }
}

resource "aws_route_table_association" "a_west" {
  provider                  = aws.west
  subnet_id                 = aws_subnet.subnet_1_west.id
  route_table_id            = aws_route_table.main_west.id
}

resource "aws_route_table_association" "b_west" {
  provider                  = aws.west
  subnet_id                 = aws_subnet.subnet_2_west.id
  route_table_id            = aws_route_table.main_west.id
}

# Route Table for Us East 1 **********************************************************
resource "aws_route_table" "main_east" {
  provider                  = aws.east
  vpc_id                    = aws_vpc.vpc_east.id

  route {
    cidr_block              = var.df_cidr_block_anywhere
    gateway_id              = aws_internet_gateway.dp6_igw_east.id
  }
}

resource "aws_route_table_association" "a_east" {
  provider                  = aws.east
  subnet_id                 = aws_subnet.subnet_1_east.id
  route_table_id            = aws_route_table.main_east.id
}

resource "aws_route_table_association" "b_east" {
  provider                  = aws.east
  subnet_id                 = aws_subnet.subnet_2_east.id
  route_table_id            = aws_route_table.main_east.id
}
