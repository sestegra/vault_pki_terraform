variable "issuer" {
  type = object({
    name             = string
    backend          = string
    organization     = string
    certificate_name = string
    key_type         = string
    key_bits         = number
    certificate      = string
  })
  description = "Issuer configuration"
}
