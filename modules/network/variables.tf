variable "vpc_cidr" {
    description = "cidr range"
    default     = "10.110.0.0/16"
}

variable "subnet_cidr" {
    type      =     "list"
    default   =    ["10.110.1.0/24", "10.110.2.0/24"]
}

variable "az" {
    type      =     "list"
    default   =     ["ap-southeast-1a", "ap-southeast-1b"]
}

