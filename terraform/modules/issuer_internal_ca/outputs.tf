output "csr" {
  description = "PEM-encoded CSR"
  value       = vault_pki_secret_backend_intermediate_cert_request.this.csr
}

output "certificate" {
  description = "PEM-encoded certificate"
  value       = vault_pki_secret_backend_intermediate_set_signed.this.certificate
}

output "issuer_id" {
  description = "ID of the issuer"
  value       = vault_pki_secret_backend_intermediate_set_signed.this.imported_issuers[0]
}
