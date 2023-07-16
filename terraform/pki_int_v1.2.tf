module "issuer_v1_2" {
  source = "./modules/issuer_external_ca"
  issuer = {
    name             = "v1.2"
    backend          = vault_mount.pki_int.path
    organization     = var.organization
    certificate_name = "Example Labs Intermediate CA v1.2"
    key_type         = var.default_key_type
    key_bits         = var.default_key_bits
    certificate      = fileexists("${path.root}/../pki_int_v1.2.crt") ? file("${path.root}/../pki_int_v1.2.crt") : null
  }
  depends_on = [vault_mount.pki_int]
}

output "csr_v1_2" {
  description = "CSR for v1.2"
  value       = module.issuer_v1_2.csr
  sensitive   = true
}

output "certificate_v1_2" {
  description = "CRT for v1.2"
  value       = module.issuer_v1_2.certificate
  sensitive   = true
}

output "issuer_v1_2" {
  description = "v1.2 issuer ID"
  value       = module.issuer_v1_2.issuer_id
}
