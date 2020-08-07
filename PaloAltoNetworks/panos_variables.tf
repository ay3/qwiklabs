variable "panos_hostname" {
  description = "The external IP address of the VM-Series instance"
  type = "string"
  default = "PUT HOSTNAME HERE"
}

variable "panos_username" {
  description = "Username of the VM-Series administrator"
  type = "string"
  default = "PUT USERNAME HERE"
}

variable "panos_password" {
  description = "Password of the VM-Series administrator"
  type = "string"
  default = "PUT PASSWORD HERE"
}
