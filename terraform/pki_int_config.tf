resource "vault_mount" "pki_int" {
  path                  = var.pki_int_mount_path
  type                  = "pki"
  description           = "PKI engine hosting intermediate CA"
  max_lease_ttl_seconds = local.duration_5y_in_sec
}
