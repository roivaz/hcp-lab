locals {
  project          = "lab"
  environment      = "dev"
  region           = "us-east-1"
  vpc_cidr         = "10.83.0.0/16"
  cluster          = "hcp"
  cluster_version  = "4.15.5"
  workers_type     = "t3a.2xlarge"
  workers_count    = 1
  name             = join("-", [local.environment, local.project, local.cluster])
  domain           = "hcp-lab.dev.3sca.net"
  oidc_bucket_name = "my-oidc-bucket"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = [module.vpc.private_subnets[0]]
}
