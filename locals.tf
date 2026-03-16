locals {
  common_tags = {
    Environment = var.environment
    Owner       = "pc"
    GitHubRepo  = "pc-sg-wrapper"
  }
  local_name = "${local.common_tags["Owner"]}-${var.environment}-${var.region}-sg"
  name = var.name == "" ? local.local_name : var.name
  tags = merge(local.common_tags, { Name = local.name })
}