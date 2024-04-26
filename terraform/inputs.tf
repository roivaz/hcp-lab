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
  domain           = "example.com"
  oidc_bucket_name = "my-oidc-bucket"
}
