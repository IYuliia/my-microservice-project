provider "kubernetes" {
  # no config_path here, provider will be injected from root
}

provider "helm" {
  kubernetes {
    # no config_path here either
  }
}
