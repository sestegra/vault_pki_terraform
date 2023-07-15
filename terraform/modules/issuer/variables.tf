variable "issuer" {
  type = object({
    name             = string
    backend          = string
    organization     = string
    certificate_name = string
    key_type         = string
    key_bits         = number
    certificate      = optional(string) # For external CA
    sign_backend     = optional(string) # For Vault CA
  })
  description = "Issuer configuration"
}
