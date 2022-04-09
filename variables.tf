variable azs {
  type = list(string)
}

variable nat_gateway_count {
  type = number
  default = 0
}

variable internet_gateway_count {
  type = number
  default = 0
}

variable vpc_id {
  description = "vpc_id"
  type = string
}

variable name {
  description = "name of seperating sunbet network"
  type = string
}

variable cidrs {
  type = list(string)
}

variable reuse_nat_ips {
  type = bool
  default = false
}

variable nat_gateway_ids {
  type = list(string)
  default = []
}

variable internet_gateway_ids {
  type = list(string)
  default = []
}

variable external_nat_ip_ids {
  type = list(string)
  default = []
}

variable inbound_acl_rules {
  type    = list(map(string))
  default = [{}]
}

variable outbound_acl_rules {
  type    = list(map(string))
  default = [{}]
}
