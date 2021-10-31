variable "service_name" {
  default = "service"
}

variable "resource_tags" {
  description = "AWS resource tags"
  default = {
    Stage   = "Prod"
    Owner   = "Cesar"
  }
}