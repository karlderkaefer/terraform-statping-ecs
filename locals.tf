locals {
  tags = {
    Environment = var.cluster_environment
    App         = var.cluster_name
    ManagedBy   = "terraform"
  }
  cluster_full_name = "${var.cluster_name}-${var.cluster_environment}"
}
