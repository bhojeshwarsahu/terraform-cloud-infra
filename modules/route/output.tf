output "route_table_ids" {
  value = { for k, rt in aws_route_table.this : k => rt.id }
}

output "route_table_associations" {
  value = aws_route_table_association.assoc
}
