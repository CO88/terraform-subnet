output subnets_ids {
  description = "List of IDs of the VPC"
  value       = aws_subnet.default.*.id
}
output route_table_ids {
  description = "List of IDs of private route tables"
  value       = var.nat_gateway_count > 0 ? aws_route_table.private.*.id : aws_route_table.public.*.id
}