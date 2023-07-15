resource "vault_mount" "pki_int" {
  path                  = var.pki_int_mount_path
  type                  = "pki"
  description           = "PKI engine hosting intermediate CA"
  max_lease_ttl_seconds = local.duration_5y_in_sec
}

resource "vault_mount" "pki_iss" {
  path                  = var.pki_iss_mount_path
  type                  = "pki"
  description           = "PKI engine hosting issuing CA"
  max_lease_ttl_seconds = local.duration_1y_in_sec
}

module "issuer_v1_1" {
  source = "./modules/issuer"
  issuer = {
    name             = "v1.1"
    backend          = var.pki_int_mount_path
    organization     = "Example"
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

module "issuer_v1_1_1" {
  source = "./modules/issuer"
  issuer = {
    name             = "v1.1.1"
    backend          = var.pki_iss_mount_path
    sign_backend     = module.issuer_v1_1.certificate != null ? var.pki_int_mount_path : null
    organization     = "Example"
    certificate_name = "Example Labs Issuing CA v1.1.1"
    key_type         = var.default_key_type
    key_bits         = var.default_key_bits
  }
  depends_on = [vault_mount.pki_iss, module.issuer_v1_1]
}
