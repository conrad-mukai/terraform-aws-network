# -----------------------------------------------------------------------------
# DEPLOY AN AWS NETWORK
# Deploy an AWS VPC with public/private subnets. The VPC will span all the
# availability zones in the targeted region.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# PROVIDER
# Configure the AWS provider. The configuration specifies the AWS region.
# -----------------------------------------------------------------------------
provider aws {
  region = var.region
}

# -----------------------------------------------------------------------------
# AVAILABILITY ZONES
# Collect availability zones in current region.
# -----------------------------------------------------------------------------
data aws_availability_zones current {}

# -----------------------------------------------------------------------------
# NETWORK
# Create a VPC with subnets that span all the availability zones in the
# current region.
# -----------------------------------------------------------------------------
module network {
  source = "../../"
  name = var.name
  vpc_cidr = var.vpc_cidr
  availability_zones = data.aws_availability_zones.current.names
  bastion_access = var.bastion_access
  private_key = var.private_key
  authorized_keys = var.authorized_keys
  key_name = var.key_name
}

# -----------------------------------------------------------------------------
# INSTANCE
# Create an EC2 instance in one of the private subnets so ssh access through
# the bastion server can be tested. We use the same key for the internal server
# that we used on the bastion. This is only for convenience.
# -----------------------------------------------------------------------------

data aws_ami ami {
  owners = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-minimal-hvm-*"]
  }
}

resource random_integer subnet {
  max = length(data.aws_availability_zones.current.names) - 1
  min = 0
}

resource aws_instance server {
  ami = data.aws_ami.ami.image_id
  instance_type = "t3.micro"
  key_name = var.key_name
  subnet_id = module.network.private_subnets[random_integer.subnet.result]["id"]
  vpc_security_group_ids = [module.network.internal_security_group_id]
}
