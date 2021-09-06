variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "m4k3_Instance"
}


variable "server_port" {
  description = "Port the server will be running on"
  type        = number
}