variable "access_key" {
     type        = string
     description = "aws access key"
}

variable "secret_key" {
    type        = string
    description = "aws secret key to login"
}

variable "region" {
   type        = string
   description = "please enter aws region"
}

variable "availabilityZone" {
    type        = string
    description = "please enter aws availability zone"
}

variable "instanceTenancy" {
    default     = "default"
    description = "please enter instance tenancy default(shared) or dedicated"
}

variable "dnsSupport" {
    default     = true
    description = "to enable DNS support for VPC(true or false)"
}

variable "dnsHostNames" {
    default     = true
    description = "to enable DNSHostNames for VPC(true or false)"
}

variable "vpcCIDRblock" {
    type        = string
    description = "please add CIDR range for VPC"
}

variable "subnetCIDRblock" {
    type        = string
    description = "please enter subnet cidr range"
}

variable "mapPublicIP" {
    default = true
}

variable "amiType" {
    default     = "ami-0bcc094591f354be2"
}

variable "instanceType" {
     type       = string
    description = "please enter instance type for creating an ec2 instance"
}

variable "projectName" {
    type        = string
    description = "please enter Project Name"
}

variable "ebsType" {
   default = "gp2"
}

variable "ebsSize" {
    type        = number
    description = "please enter root-block-device volume attaching to an ec2 instance"
}

variable "ingressCIDRblock" {
    type    = list
    default = [ "157.46.208.25/32" ]
}

variable "egressCIDRblock" {
    type    = list
    default = [ "0.0.0.0/0" ]
}

variable "keyName" {
   type         = string
   description = "please enter key pair name"
}
