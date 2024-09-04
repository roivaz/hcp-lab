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

# vault provider is not used in this example
# but Terraform requires that it's declared
provider "vault" {
  address = "https://placeholder"
}