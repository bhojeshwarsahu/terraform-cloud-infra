locals {
  first_pub_subnet = length(values(var.public_subnet_ids)) > 0 ? element(values(var.public_subnet_ids), 0) : ""
  nat_map          = var.create_per_az ? var.public_subnet_ids : { "single" = local.first_pub_subnet }
}

resource "aws_eip" "nat" {
  for_each = local.nat_map

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-nat-eip-${each.key}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_map

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-nat-${each.key}"
    }
  )

  depends_on = [aws_eip.nat]
}