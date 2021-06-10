variable "location" {}

variable "prefix" {
  type    = string
  default = "my"
}

variable "tags" {
  type = map

  default = {
    Environment = "Terraform GS"
    Dept        = "Engineering"
  }
}

variable "client_secret" {
  type    = string
  default = "2IBBeD5i-rLN4bvqNR9Hge848AP6wlvj5o"
}
