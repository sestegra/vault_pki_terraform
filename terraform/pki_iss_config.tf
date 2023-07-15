resource "vault_mount" "pki_iss" {
  path                  = var.pki_iss_mount_path
  type                  = "pki"
  description           = "PKI engine hosting issuing CA"
  max_lease_ttl_seconds = local.duration_1y_in_sec
}

resource "vault_pki_secret_backend_role" "example_com" {
  backend                     = vault_mount.pki_iss.path
  name                        = "example_com"
  organization                = [var.organization]
  key_type                    = var.default_key_type
  key_bits                    = var.default_key_bits
  max_ttl                     = local.duration_1hr_in_sec
  allowed_domains             = ["example.com"]
  allow_subdomains            = true
  allow_ip_sans               = true
  allow_wildcard_certificates = false
  issuer_ref                  = "default"
}
