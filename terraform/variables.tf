variable "public_key" {
  description = "The path to the public SSH key that will be used to access the instances"
  type        = string
}

# HACK: since the provider removes the default security group from instances
# if we assign a new one, we have to manually assign the default security group
# back to the instances
variable "default_security_group_id" {
  description = "The ID of the default security group"
  type        = string
}

variable "satellite_count" {
  description = "The number of Linstor satellite nodes to create"
  type        = number
  default     = 3
}

variable "satellite_volume_size" {
  description = "The size of the volumes for Linstor satellite nodes"
  type        = number
  default     = 50
}
