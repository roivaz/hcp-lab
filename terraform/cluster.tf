module "hostedcluster" {
  #   source                = "git@github.com:3scale-ops/tf-hypershift-hostedcluster?ref=tags/0.3.0"
  source                = "/home/roi/github.com/3scale/tf-hypershift-hostedcluster"
  environment           = local.environment
  project               = local.project
  cluster               = local.cluster
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = [module.vpc.private_subnets[0]]
  oidc_bucket_name      = local.oidc_bucket_name
  consumer_domain       = local.domain
  release_image         = "quay.io/openshift-release-dev/ocp-release:${local.cluster_version}-multi-x86_64"
  workers_instance_type = local.workers_type
  worker_replicas       = local.workers_count
  github_oauth_enabled  = false
  namespace             = "clusters"
  pull_secret           = "hypershift-pull-secret"
  ssh_key               = "hypershift-ssh-key"
  managedclusterset     = "hypershift"
  managedcluster_extra_labels = [
    "environment=${local.environment}",
  ]
  depends_on = [
    module.vpc
  ]
}

// TODO: make this bit a part of the module
resource "aws_ec2_tag" "priv_subnets" {
  count       = length(module.vpc.private_subnets)
  resource_id = module.vpc.private_subnets[count.index]
  key         = "kubernetes.io/cluster/${local.name}"
  value       = "shared"
}
resource "aws_ec2_tag" "pub_subnets" {
  count       = length(module.vpc.public_subnets)
  resource_id = module.vpc.public_subnets[count.index]
  key         = "kubernetes.io/cluster/${local.name}"
  value       = "shared"
}