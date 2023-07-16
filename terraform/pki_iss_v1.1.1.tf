module "issuer_v1_1_1" {
  source = "./modules/issuer_internal_ca"
  issuer = {
    name             = "v1.1.1"
    backend          = vault_mount.pki_iss.path
    parent_backend   = module.issuer_v1_1.certificate != null ? vault_mount.pki_int.path : null
    organization     = var.organization
    certificate_name = "Example Labs Issuing CA v1.1.1"
    key_type         = var.default_key_type
    key_bits         = var.default_key_bits
  }
  depends_on = [module.issuer_v1_1]
}

output "certificate_v1_1_1" {
  description = "CRT for v1.1.1"
  value       = module.issuer_v1_1_1.certificate
  sensitive   = true
}

output "issuer_v1_1_1" {
  description = "Issuer ID for v1.1.1"
  value       = module.issuer_v1_1_1.issuer_id
}
