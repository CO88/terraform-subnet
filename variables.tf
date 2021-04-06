variable azs {
  type = list(string)
}

variable vpc_id {
  description = "vpc_id"
  type = string
}

variable environment_name {
  type = string
}

variable name {
  description = "name of seperating sunbet network"
  type = string
}

variable public_subnets_ids {
  description = "list of id of public subnet"
  type = list(string)
}

variable private_subnets {
  type = list(string)
}

variable reuse_nat_ips {
  type = bool
  default = false
}

variable nat_gateway_ids {
  type = list(string)
}

variable external_nat_ip_ids {
  type = list(string)
  default = []
}

variable private_inbound_acl_rules {
  type    = list(map(string))
  default = [{}]
}

variable private_outbound_acl_rules {
  type    = list(map(string))
  default = [{}]
}