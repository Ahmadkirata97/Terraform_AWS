output "public_dns" {
  value = aws_instance.out_var_instance.public_dns
  description = "this is public dns"
  # if we doesnt want this information to be printed at the terminal we just type 
  sensitive = true 
}

output "instance_subnet_id" {
  
  value = aws_instance.out_var_instance.subnet_id
}