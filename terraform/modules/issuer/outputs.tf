output "csr" {
  value = vault_pki_secret_backend_intermediate_cert_request.csr
}

output "certificate" {
  value = length(vault_pki_secret_backend_intermediate_set_signed.external) > 0 ? vault_pki_secret_backend_intermediate_set_signed.external[0].certificate : (length(vault_pki_secret_backend_intermediate_set_signed.internal) > 0 ? vault_pki_secret_backend_intermediate_set_signed.internal[0].certificate : null)
}
