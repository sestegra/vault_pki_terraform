module "issuer_v1_2_1" {
  source = "./modules/issuer"
  issuer = {
    name             = "v1.2.1"
    backend          = vault_mount.pki_iss.path
    sign_backend     = module.issuer_v1_1.certificate != null ? vault_mount.pki_int.path : null
    organization     = var.organization
    certificate_name = "Example Labs Issuing CA v1.2.1"
    key_type         = var.default_key_type
    key_bits         = var.default_key_bits
  }
  depends_on = [module.issuer_v1_2]
}

output "certificate_v1_2_1" {
  description = "CRT for v1.2.1"
  value       = module.issuer_v1_2_1.certificate
  sensitive   = true
}

output "issuer_v1_2_1" {
  description = "Issuer ID for v1.2.1"
  value       = module.issuer_v1_2_1.issuer_id
}
