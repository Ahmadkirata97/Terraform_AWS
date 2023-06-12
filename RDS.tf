provider "aws" {
  region = "us-east-1"
}

#resource "aws_db_instance" "terraform_rds" {
  
#  allocated_storage = 10
#  db_name = "terraform_rds"
#  engine = "mysql"
#  engine_version = "5.7"
#  instance_class = "t2.micro"
#  username = "ahmad"
#  password = "ahmad123"
#  skip_final_snapshot = true
#  parameter_group_name = "default.mysql5.7"
#}

# RDS Custom for oracle Usage with replica 

data "aws_rds_orderable_db_instance" "custom-oracle"{

  engine = "custom-oracle-ee"
  engine_version = ""
  license_model = "bring your own license"
  storage_type = "gp3"
  preferred_instance_classes = [ "t2.micro" , "db.r5.16xlarge" ]
}

data "aws_kms_key" "by_id" {
  
  key_id = "id of wanted key"
}

resource "aws_db_instance" "terraform_instance" {
  
  allocated_storage = 50
  max_allocated_storage = 100
  auto_minor_version_upgrade = false
  custom_iam_instance_profile = "iam we want"
  db_subnet_group_name = local.db_subnet_group_name
  engine = data.aws_rds_orderable_db_instance.custom-oracle.engine
  engine_version = data.aws_rds_orderable_db_instance.custom-oracle.engine_version
  identifier = "ee-instance-demo"
  instance_class = data.aws_rds_orderable_db_instance.custom-oracle.preferred_instance_classes
  kms_key_id = data.aws_kms_key.by_id.arn
  license_model = data.aws_rds_orderable_db_instance.custom-oracle.license_model
  multi_az = false
  password = "avoid plain text passwd"
  username = "ahmad"
  storage_encrypted = true
  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

resource "aws_db_instance" "terraform_test_replica" {
  
  replicate_source_db = aws_db_instance.terraform_instance.id
  replica_mode = "mounted"
  auto_minor_version_upgrade = false
  custom_iam_instance_profile = "iam we want"
  backup_retention_period = 7
  identifier = "ee-instacne-replica"
  instance_class = data.aws_rds_orderable_db_instance.custom-oracle.preferred_instance_classes
  kms_key_id = data.aws_kms_key.by_id.arn
  multi_az = false
  skip_final_snapshot = true
  storage_encrypted = true
  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}