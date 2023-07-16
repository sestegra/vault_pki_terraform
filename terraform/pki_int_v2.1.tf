module "issuer_v2_1" {
  source = "./modules/issuer_external_ca"
  issuer = {
    name             = "v2.1"
    backend          = vault_mount.pki_int.path
    organization     = var.organization
    certificate_name = "Example Labs Intermediate CA v2.1"
    key_type         = var.default_key_type
    key_bits         = var.default_key_bits
    certificate      = fileexists("${path.root}/../pki_int_v2.1.crt") ? file("../pki_int_v2.1.crt") : null
  }
  depends_on = [vault_mount.pki_int]
}

output "csr_v2_1" {
  description = "CSR for v2.1"
  value       = module.issuer_v2_1.csr
  sensitive   = true
}

output "certificate_v2_1" {
  description = "CRT for v2.1"
  value       = module.issuer_v2_1.certificate
  sensitive   = true
}

output "issuer_v2_1" {
  description = "v2.1 issuer ID"
  value       = module.issuer_v2_1.issuer_id
}
