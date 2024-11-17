variable "public_key" {
  description = "The path to the public SSH key that will be used to access the instances"
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
