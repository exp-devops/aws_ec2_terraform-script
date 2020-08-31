provider "aws" {
  version        = "~> 2.0"
  region         = var.region
  access_key     = var.access_key
  secret_key     = var.secret_key
}
# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames

tags = {
    Name    = "${var.projectName}-vpc"
    Project = var.projectName
 }

} # end resource

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.My_VPC.id

  tags = {
     Name    = "${var.projectName}-IG"
    Project = var.projectName
  }
}

# create the Subnet
resource "aws_subnet" "My_VPC_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone

tags = {
   Name    = "${var.projectName}-subnet"
   Project = var.projectName
}

}

# Create the Security Group
resource "aws_security_group" "securityGroup" {
  vpc_id       = aws_vpc.My_VPC.id
  name         = "${var.projectName}-sg"
  description  = "My VPC Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
 #   ipv6_cidr_blocks = ["2409:4073:286:938a:3164:f3a4:fb0:3d59"]
 
  } 
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
   Name    = "${var.projectName}-sg"
   Project = var.projectName
}

} # end resource

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.keyName}"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

resource "aws_instance" "ec2Instance" {
  ami                      = var.amiType
  instance_type            = var.instanceType
  availability_zone        = var.availabilityZone
  vpc_security_group_ids   = [ "${aws_security_group.securityGroup.id}" ]
  subnet_id                = "${aws_subnet.My_VPC_Subnet.id}"
  key_name                 = "${aws_key_pair.generated_key.key_name}"
root_block_device {
        volume_type  = var.ebsType
        volume_size  = var.ebsSize

}
tags = {
        Name    = "${var.projectName}-ec2-instance"
        Project = var.projectName
  }

}

# resource "aws_ebs_volume" "ebsVolume" {
#  availability_zone = var.availabilityZone
#  type              = var.ebsType
#  size              = var.ebsSize

#  tags = {
#     Name    = "${var.projectName}-ebs"
#     Project = var.projectName
#  }
# }

# resource "aws_volume_attachment" "ebsVolumeAttachment" {
# device_name = "/dev/sdc"
# volume_id = "${aws_ebs_volume.ebsVolume.id}"
# instance_id = "${aws_instance.ec2Instance.id}"
#}

resource "aws_eip_association" "eipAssoc" {
  instance_id   = aws_instance.ec2Instance.id
  allocation_id = aws_eip.eip.id
}

resource "aws_eip" "eip" {
  vpc = true

 tags = {
     Name    = "${var.projectName}-ip"
     Project = var.projectName
  }

}


