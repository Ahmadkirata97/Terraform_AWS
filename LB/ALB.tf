resource "aws-lb" "ALB_Terraform" {
  name = "ALB_Terraform"
  # to chose if the load balancer is internet facing or internal 
  internal = false 
  # Select the load balancer type
  load_balancer_type = "application"
  # Attach secgroups for load balancer 
  security_groups = [aws_security_group.terraform_sg_for_LB]
  # Choose subnets which the load balancer will work in 
  subnets = [subnet-id1,subnet-subnet-id2]
  enable_deletion_protection = true 
}