output "csr" {
  description = "PEM-encoded CSR"
  value       = vault_pki_secret_backend_intermediate_cert_request.this.csr
}

output "certificate" {
  description = "PEM-encoded certificate"
  value       = length(vault_pki_secret_backend_intermediate_set_signed.this) > 0 ? vault_pki_secret_backend_intermediate_set_signed.this[0].certificate : null
}

output "issuer_id" {
  description = "ID of the issuer"
  value       = length(vault_pki_secret_backend_intermediate_set_signed.this) > 0 ? vault_pki_secret_backend_intermediate_set_signed.this[0].imported_issuers[0] : null
}
