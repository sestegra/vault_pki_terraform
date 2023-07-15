resource "vault_mount" "pki_int" {
  path                  = var.pki_int_mount_path
  type                  = "pki"
  description           = "PKI engine hosting intermediate CA"
  max_lease_ttl_seconds = local.duration_5y_in_sec
}

resource "vault_pki_secret_backend_config_issuers" "int" {
  count   = var.int_default_issuer != null ? 1 : 0
  backend = vault_mount.pki_int.path
  default = var.iss_default_issuer
}
