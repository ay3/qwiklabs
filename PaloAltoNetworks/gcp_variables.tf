variable "gcp_project_id" {
  description = "GCP Project ID"
  type = "string"
  default = "gcp_project_id_HERE"
}

variable "gcp_region" {
  description = "ADD_gcp_region_description"
  type = "string"
  default = "PUT_gcp_region_HERE"
}

variable "gcp_credentials_file" {
  description = "Full path to the JSON credentials file"
  type = "string"
  default = "../gcp_compute_key.json"
}

variable "gcp_ssh_key" {
  description = "Full path to the SSH public key file"
  type = "string"
  default = "../../../.ssh/lab_ssh_key.pub"
}
