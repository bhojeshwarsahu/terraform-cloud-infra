resource "aws_route_table" "this" {
  for_each = var.route_tables

  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-rt-${each.key}"
      Environment = var.environment
      Type        = each.key
    }
  )
}

resource "aws_route" "routes" {
  for_each = {
    for rt_key, rt in var.route_tables :
    "${rt_key}" => rt.routes
  }

  route_table_id         = aws_route_table.this[each.key].id
  destination_cidr_block = each.value[0].destination

  gateway_id     = each.value[0].target_type == "igw" ? each.value[0].target_id : null
  nat_gateway_id = each.value[0].target_type == "nat" ? each.value[0].target_id : null

  depends_on = [aws_route_table.this]
}

resource "aws_route_table_association" "assoc" {
  for_each = {
    for rt_key, rt in var.route_tables :
    rt_key => rt.subnets
  }

  route_table_id = aws_route_table.this[each.key].id
  subnet_id      = var.subnet_ids[each.value[0]]

  depends_on = [aws_route_table.this]
}
