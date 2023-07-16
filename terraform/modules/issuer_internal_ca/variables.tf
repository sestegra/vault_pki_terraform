variable "issuer" {
  type = object({
    name             = string
    backend          = string
    organization     = string
    certificate_name = string
    key_type         = string
    key_bits         = number
    parent_backend   = string
  })
  description = "Issuer configuration"
}
