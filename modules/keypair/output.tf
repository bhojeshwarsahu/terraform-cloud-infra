output "key_name" {
  description = "AWS key pair name"
  value       = aws_key_pair.this.key_name
}

output "key_fingerprint" {
  description = "Fingerprint of the uploaded public key"
  value       = aws_key_pair.this.fingerprint
}

output "public_key" {
  description = "Public key uploaded to AWS (OpenSSH format)"
  value       = aws_key_pair.this.public_key
  sensitive   = false
}

output "private_key_pem" {
  description = "Generated private key PEM (sensitive). Only populated when module generated the key."
  value       = length(tls_private_key.generated) > 0 ? tls_private_key.generated[0].private_key_pem : ""
  sensitive   = true
}

output "private_key_path" {
  description = "If the module wrote the private key to disk, this is the path (empty otherwise)"
  value       = var.save_private_key && length(local_file.private_key) > 0 ? local_file.private_key[0].filename : ""
}
