# Syntax of terraform variable :
variable "tyoinstance" {
  
  description = "any describtion we want"
  #type of the variable
  type = string
  #the default value of the variable 
  default = "value"
}

variable "num_of_instances" {
    description = "number of instances we want to create"
    type = number
    default = 2
}