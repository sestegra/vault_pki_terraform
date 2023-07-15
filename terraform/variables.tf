variable "pki_int_mount_path" {
  type        = string
  description = "Path to the PKI's intermediate CA secret backend"
  default     = "pki_int"
}

variable "pki_iss_mount_path" {
  type        = string
  description = "Path to the PKI's issuing CA secret backend"
  default     = "pki_iss"
}

variable "default_key_type" {
  type        = string
  description = "Default key type"
  default     = "ec"
}

variable "default_key_bits" {
  type        = number
  description = "Default key bits"
  default     = 256
}
