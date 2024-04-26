resource "aws_eip" "nat" {
  count = 2
}

module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = local.vpc_cidr
  networks = [
    {
      name     = "az1-pub"
      new_bits = 6
    },
    {
      name     = "az2-pub"
      new_bits = 6
    },
    {
      name     = "az1-priv"
      new_bits = 6
    },
    {
      name     = "az2-priv"
      new_bits = 6
    },
  ]
}

# create VPC
module "vpc" {
  source                          = "terraform-aws-modules/vpc/aws"
  version                         = "5.6.0"
  name                            = "hcp-vpc"
  cidr                            = module.subnet_addrs.base_cidr_block
  enable_dns_support              = true
  enable_dns_hostnames            = true
  azs                             = ["${local.region}a", "${local.region}b"]
  private_subnets                 = [module.subnet_addrs.network_cidr_blocks["az1-pub"], module.subnet_addrs.network_cidr_blocks["az2-pub"]]
  public_subnets                  = [module.subnet_addrs.network_cidr_blocks["az1-priv"], module.subnet_addrs.network_cidr_blocks["az2-priv"]]
  enable_nat_gateway              = true
  one_nat_gateway_per_az          = true
  reuse_nat_ips                   = true
  create_elasticache_subnet_group = true
  external_nat_ip_ids             = aws_eip.nat.*.id
  public_subnet_tags = {
    Name = "vpc-region-1-pubnet"
  }
  private_subnet_tags = {
    Name = "vpc-region-1-privnet"
  }
}

# delete all default rules from default SG
resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id
}