variable "ec2_instance_type" {
  description = "The type of EC2 instance to create"
  default     = "t3.micro"
  type = string
}
variable "ec2_root_storage_size" {     
  description = "The size of the root storage volume in GB"
  default     = 10
  type = number
}

variable "ec2_ami_id" {
  description = "The AMI ID for the EC2 instance"
  default     = "ami-091138d0f0d41ff90"
  type = string
}