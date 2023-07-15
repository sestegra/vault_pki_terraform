# Generate a CSR
resource "vault_pki_secret_backend_intermediate_cert_request" "csr" {
  backend      = var.issuer.backend
  type         = "internal"
  organization = var.issuer.organization
  common_name  = var.issuer.certificate_name
  key_type     = var.issuer.key_type
  key_bits     = var.issuer.key_bits
  key_name     = var.issuer.name
}

## External CA
# Store the signed certificate
resource "vault_pki_secret_backend_intermediate_set_signed" "external" {
  count       = var.issuer.certificate != null ? 1 : 0
  backend     = var.issuer.backend
  certificate = var.issuer.certificate
}

# Name the certificate issuer
resource "vault_pki_secret_backend_issuer" "external" {
  count       = var.issuer.certificate != null ? 1 : 0
  backend     = var.issuer.backend
  issuer_ref  = vault_pki_secret_backend_intermediate_set_signed.external[0].imported_issuers[0]
  issuer_name = var.issuer.name
}

## Vault CA
# Sign the CSR
resource "vault_pki_secret_backend_root_sign_intermediate" "internal" {
  count       = var.issuer.sign_backend != null ? 1 : 0
  backend     = var.issuer.sign_backend
  common_name = var.issuer.certificate_name
  csr         = vault_pki_secret_backend_intermediate_cert_request.csr.csr
}

# Store the signed certificate
resource "vault_pki_secret_backend_intermediate_set_signed" "internal" {
  count       = var.issuer.sign_backend != null ? 1 : 0
  backend     = var.issuer.backend
  certificate = vault_pki_secret_backend_root_sign_intermediate.internal[0].certificate_bundle
}

# Name the certificate issuer
resource "vault_pki_secret_backend_issuer" "internal" {
  count       = var.issuer.sign_backend != null ? 1 : 0
  backend     = var.issuer.backend
  issuer_ref  = vault_pki_secret_backend_intermediate_set_signed.internal[0].imported_issuers[0]
  issuer_name = var.issuer.name
}
