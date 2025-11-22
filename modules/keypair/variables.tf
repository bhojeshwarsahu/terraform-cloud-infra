variable "name" {
  description = "Name for the AWS key pair (must be unique per region/account)"
  type        = string
}

variable "public_key" {
  description = "Public key content in OpenSSH format. If provided this will be used. Otherwise the module can generate a keypair."
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "Optional path to a public key file. If provided, file(public_key_path) will be used (ignored if `public_key` is set)."
  type        = string
  default     = ""
}

variable "generate_key" {
  description = "If true and no public_key is provided, module will generate an RSA keypair locally and upload the public key."
  type        = bool
  default     = false
}

variable "rsa_bits" {
  description = "Key size for generated RSA key (only used if generate_key = true)."
  type        = number
  default     = 4096
}

variable "save_private_key" {
  description = "If true and the module generates a key, save the private key to a local file at private_key_path. Be careful: storing private keys on disk has security implications."
  type        = bool
  default     = false
}

variable "private_key_path" {
  description = "Local path to write the generated private key (used only when save_private_key = true). Example: \"../secrets/dev_key.pem\""
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to attach to the AWS key pair resource."
  type        = map(string)
  default     = {}
}