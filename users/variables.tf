variable "aws_profile" {
  description = "Profile to use to connect to AWS"
  default = "lunatech-devops-training"
}

variable "emails_map" {
  description = "Map of email to pgp key"
  type = "map"
  default = {}
}

variable "group_name" {
  description = "Name of the group to create"
  default = "terraforming-aws-workshop"
}
