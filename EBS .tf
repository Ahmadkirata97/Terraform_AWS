provider "aws" {
  region = "us-east-1"
}


# to use customer managed CMK to replace the managed AWS key 
resource "aws_ebs_default_kms_key" "name" {
  
  key_arn = "the arn of the key"
}

# to manage whether default ebs encryption is enabled in a specified region in my account we can use the resource 
resource "aws_ebs_encryption_by_default" "terraform" {

    enabled = true
}

#And we can use it as "data" to check if default enc is enabled in the specified region 

# Create a snapshot of an ebs volume 
resource "aws_ebs_volume" "terraform_volume" {
  
  availability_zone = "AZ we want to create the volume in"
  size = 40

  tags = {
    name = "terraform_volume"
  }
}

resource "aws_ebs_snapshot" "terraform_snapshot" {
  
  volume_id = aws_ebs_volume.terraform_volume
  tags = {

    name = "terraform_snapshot"
  }
}

#AWS EBS snapshot copy

resource "aws_ebs_snapshot_copy" "terraform_snapshot_copy" {
  
  source_snapshot_id = aws_ebs_snapshot.terraform_snapshot.id
  source_region = "us-east-1"

  tags = {

    name = "terraform_snapshot_copy"
  }
}

#Add permission to create volumes of a specified snapshot

resource "aws_snapshot_create_volume_permission" "terraform_snapshot_permission" {
  
  snapshot_id = aws_ebs_snapshot.terraform_snapshot.id
  account_id = "id of the account"

}

#To attach an EBS volume to an instance we use 
resource "aws_volume_attachment" "terraform_attachment" {
  
  device_name = "/dev/sdh"
  volume_id = aws_ebs_volume.terraform_volume.id
  instance_id = "the id of the instance we want to attach the volume to "
}

#Data Sources :

# To retrieve default ebs encryption KMS key 
data "aws_ebs_default_kms_key" "retrieve_key" {}

resource "aws_ebs_volume" "t_volume" {

  availability_zone = "us-east-1c"
  encrypted = true
  kms_key_id = data.aws_ebs_default_kms_key.retrieve_key.key_arn
}

# To retrieve info about a snapshot and use it in another resources :
data "aws_ebs_snapshot" "retrieve_snapshot_data" {
  
  most_recent = true
  owners = ["self"]
  filter {
    name = "volum-size"
    values = ["40"]
  }
}

#To get a list of EBS Snapshots IDs 
data "aws_ebs_snapshot_ids" "retrieve_ids" {
  
  owners = ["self"]
  filter {
    name = "volume-size"
    values = ["40"]
  }
}

#To get info about EBS Volume
data "aws_ebs_volume" "retrieve_volume_info" {
  
  most_recent = true
  filter {
    name = "volume-size"
    values = ["40"]
  }
  filter {
    name = "volume-type"
    values = ["gp2"]
  }
}

#To get a list of EBS IDs
data "aws_ebs_volumes" "retrieve_ids" {
  
  tags = {
    volumeSet = "TestVolumeSet"
  }
}

data "aws_ebs_volume" "retrieve_volume" {
  
  for_each = data.aws_ebs_volumes.retrieve_ids
  filter {
    name = "volume-id"
    values = [each.value]
  }
}

output "availability_zone_to_volume_id" {
  value = { for s in data.aws_ebs_volume.example : s.id => s.availability_zone }
}