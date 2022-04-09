locals {
  nat_gateway_count = var.nat_gateway_count
  internet_gateway_count = var.internet_gateway_count
}

resource aws_subnet default {
  # private_subnet에 개수에 따라 반복
  count = length(var.cidrs) > 0 ? length(var.cidrs) : 0
  vpc_id            = var.vpc_id
  cidr_block        = var.cidrs[count.index]
  availability_zone = element(var.azs, count.index)
  tags = {
    "Name" = format(
        "%s-%s",
        var.name,
        element(var.azs, count.index)
      )
  }
}

################
# public routes
################
resource aws_route_table public {
  count = local.internet_gateway_count
  vpc_id = var.vpc_id
  tags = {
    "Name" = format("%s-%s", var.name, element(var.azs, count.index))
  }
}

#########################
# route table association
#########################

resource aws_route_table_association public {
  count = local.internet_gateway_count > 0 ? (length(var.cidrs) > 0 ? length(var.cidrs) : 0) : 0
  subnet_id = element(aws_subnet.default.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

##################
# internet gateway
##################

resource aws_route internet_gateway {
  count = local.internet_gateway_count
  route_table_id = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = element(var.internet_gateway_ids, count.index)
  timeouts {
    create = "5m"
  }
}

################
# private routes
################
resource aws_route_table private {
  count = local.nat_gateway_count
  vpc_id = var.vpc_id
  tags = {
    "Name" = format("%s-%s", var.name, element(var.azs, count.index))
  }
}

#########################
# route table association
#########################
resource aws_route_table_association private {
  count = local.nat_gateway_count > 0 ? (length(var.cidrs) > 0 ? length(var.cidrs) : 0 ) : 0
  subnet_id = element(aws_subnet.default.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

#############
# nat gateway
#############
resource aws_route private_nat_gateway {
  count = local.nat_gateway_count
  route_table_id = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = element(var.nat_gateway_ids, count.index)
  timeouts {
    create = "5m"
  }
}

######################
# Private Network ACLs
######################
resource aws_network_acl default {
  count = length(var.cidrs) > 0 ? 1 : 0
  vpc_id = var.vpc_id
  subnet_ids = aws_subnet.default.*.id
  tags = {
    "Name" = format("%s", var.name)
  }
}

resource aws_network_acl_rule private_inbound {
  count = length(var.private_subnets) > 0 ? length(var.private_inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.private[0].id

  egress          = false
  rule_number     = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_inbound_acl_rules[count.index],"from_port", null)
  to_port         = lookup(var.private_inbound_acl_rules[count.index],"to_port", null)
  icmp_code       = lookup(var.private_inbound_acl_rules[count.index],"icmp_code", null)
  icmp_type       = lookup(var.private_inbound_acl_rules[count.index],"icmp_type", null)
  protocol        = var.private_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource aws_network_acl_rule private_outbound {
  count = length(var.private_subnets) > 0 ? length(var.private_outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.private[0].id

  egress          = true
  rule_number     = var.private_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_outbound_acl_rules[count.index],"from_port", null)
  to_port         = lookup(var.private_outbound_acl_rules[count.index],"to_port", null)
  icmp_code       = lookup(var.private_outbound_acl_rules[count.index],"icmp_code", null)
  icmp_type       = lookup(var.private_outbound_acl_rules[count.index],"icmp_type", null)
  protocol        = var.private_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}
