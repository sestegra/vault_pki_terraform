locals {
  has_certificate = var.issuer.certificate != null || var.issuer.sign_backend != null
  certificate = (
    var.issuer.certificate != null ?
    var.issuer.certificate : (
      var.issuer.sign_backend != null ?
      vault_pki_secret_backend_root_sign_intermediate.this[0].certificate_bundle : null
    )
  )
}

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

# Sign the CSR (only if for internal CA)
resource "vault_pki_secret_backend_root_sign_intermediate" "this" {
  count        = var.issuer.sign_backend != null ? 1 : 0
  backend      = var.issuer.sign_backend
  organization = var.issuer.organization
  common_name  = var.issuer.certificate_name
  csr          = vault_pki_secret_backend_intermediate_cert_request.this.csr
}

# Store the signed certificate
resource "vault_pki_secret_backend_intermediate_set_signed" "this" {
  count       = local.has_certificate ? 1 : 0
  backend     = var.issuer.backend
  certificate = local.certificate
}

# Name the certificate issuer
resource "vault_pki_secret_backend_issuer" "this" {
  count       = local.has_certificate ? 1 : 0
  backend     = var.issuer.backend
  issuer_ref  = vault_pki_secret_backend_intermediate_set_signed.this[0].imported_issuers[0]
  issuer_name = var.issuer.name
}
