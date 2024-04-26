provider "aws" {
  region = local.region
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
  experiments {
    manifest = true
  }
}

provider "vault" {
  address = "https://vault.mgmt.3sca.net"
}