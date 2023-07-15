module "issuer_v1_1" {
  source = "./modules/issuer"
  issuer = {
    name             = "v1.1"
    backend          = vault_mount.pki_int.path
    organization     = var.organization
    certificate_name = "Example Labs Intermediate CA v1.1"
    key_type         = var.default_key_type
    key_bits         = var.default_key_bits
    certificate      = fileexists("${path.root}/../pki_int_v1.1.crt") ? file("../pki_int_v1.1.crt") : null
  }
  depends_on = [vault_mount.pki_int]
}

output "csr_v1_1" {
  description = "CSR for v1.1"
  value       = module.issuer_v1_1.csr
  sensitive   = true
}

output "certificate_v1_1" {
  description = "CRT for v1.1"
  value       = module.issuer_v1_1.certificate
  sensitive   = true
}

output "issuer_v1_1" {
  description = "v1.1 issuer ID"
  value       = module.issuer_v1_1.issuer_id
}
