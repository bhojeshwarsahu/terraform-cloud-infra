locals {
  public_key_inline = trimspace(var.public_key)

  public_key_from_file = (
    var.public_key == "" && var.public_key_path != "" ?
    trimspace(file(var.public_key_path)) :
    ""
  )

  public_key_effective = (
    local.public_key_inline != "" ?
    local.public_key_inline :
    local.public_key_from_file
  )
}

resource "tls_private_key" "generated" {
  count = (var.generate_key && local.public_key_effective == "") ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "this" {
  key_name = var.name

  public_key = (
    local.public_key_effective != "" ?
    local.public_key_effective :
    (
      length(tls_private_key.generated) > 0 ?
      tls_private_key.generated[0].public_key_openssh :
      ""
    )
  )

  tags = var.tags
}

resource "local_file" "private_key" {
  count = (
    var.save_private_key &&
    length(tls_private_key.generated) > 0
  ) ? 1 : 0

  filename        = var.private_key_path
  content         = tls_private_key.generated[0].private_key_pem
  file_permission = "0600"
}
