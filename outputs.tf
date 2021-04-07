output private_subnets {
  description = "List of IDs of the VPC"
  value       = aws_subnet.private.*.id
}

output private_route_table_ids {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private.*.id
}