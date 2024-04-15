

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "acl-${var.basename}-public"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "acl-${var.basename}-private"
  }
}

resource "aws_network_acl_rule" "public_egress" {
  network_acl_id = aws_network_acl.public.id

  for_each = { for idx, rule in var.public_nacls_egress : idx => rule }

  rule_number    = each.value.rule_number
  rule_action         = each.value.action
  protocol       = each.value.protocol
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  cidr_block     = each.value.cidr_block
  icmp_code      = each.value.icmp_code
  icmp_type      = each.value.icmp_type
  egress         = each.value.egress

  depends_on = [aws_network_acl.public]
}

resource "aws_network_acl_rule" "public_ingress_rules" {
  network_acl_id = aws_network_acl.public.id

  for_each = { for idx, rule in var.public_nacls_ingress : idx => rule }

  rule_number    = each.value.rule_number
  rule_action         = each.value.action
  protocol       = each.value.protocol
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  cidr_block     = each.value.cidr_block
  icmp_code      = each.value.icmp_code
  icmp_type      = each.value.icmp_type
  egress         = each.value.egress

  depends_on = [aws_network_acl.public]
}

resource "aws_network_acl_rule" "private_egress_rules" {
  network_acl_id = aws_network_acl.private.id

  for_each = { for idx, rule in var.private_nacls_egress : idx => rule }

  rule_number    = each.value.rule_number
  rule_action    = each.value.action
  protocol       = each.value.protocol
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  cidr_block     = each.value.cidr_block
  icmp_code      = each.value.icmp_code
  icmp_type      = each.value.icmp_type
  egress         = each.value.egress

  depends_on = [aws_network_acl.private]
}

resource "aws_network_acl_rule" "private_ingress_rules" {
  network_acl_id = aws_network_acl.private.id

  for_each = { for idx, rule in var.private_nacls_ingress : idx => rule }

  rule_number    = each.value.rule_number
  rule_action         = each.value.action
  protocol       = each.value.protocol
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  cidr_block     = each.value.cidr_block
  icmp_code      = each.value.icmp_code
  icmp_type      = each.value.icmp_type
  egress         = each.value.egress

  depends_on = [aws_network_acl.private]
}

