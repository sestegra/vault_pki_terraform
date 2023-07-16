# Generate a key
resource "vault_pki_secret_backend_key" "this" {
  backend  = var.issuer.backend
  type     = "internal"
  key_type = var.issuer.key_type
  key_bits = var.issuer.key_bits
  key_name = var.issuer.name
}

# Generate a CSR
resource "vault_pki_secret_backend_intermediate_cert_request" "this" {
  backend      = var.issuer.backend
  type         = "existing"
  organization = var.issuer.organization
  common_name  = var.issuer.certificate_name
  key_ref      = vault_pki_secret_backend_key.this.key_id
}

# Store the signed certificate
resource "vault_pki_secret_backend_intermediate_set_signed" "this" {
  count       = var.issuer.certificate != null ? 1 : 0
  backend     = var.issuer.backend
  certificate = var.issuer.certificate
}

# Name the issuer
resource "vault_pki_secret_backend_issuer" "this" {
  count       = var.issuer.certificate != null ? 1 : 0
  backend     = var.issuer.backend
  issuer_ref  = vault_pki_secret_backend_intermediate_set_signed.this[0].imported_issuers[0]
  issuer_name = var.issuer.name
}
