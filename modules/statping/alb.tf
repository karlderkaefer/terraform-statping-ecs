data "aws_vpc" "default" {
  id = var.cluster_vpc_id
}

resource "aws_alb" "main" { #tfsec:ignore:AWS005
  name            = substr("${local.cluster_full_name}-lb", 0, 32)
  subnets         = var.cluster_public_subnets
  security_groups = [aws_security_group.aws-lb.id]
  tags = {
    Name = "${var.cluster_name}-alb"
  }
}

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "aws-lb" {
  name        = substr("${local.cluster_full_name}-lb", 0, 32)
  description = "Controls access to the ALB"
  vpc_id      = var.cluster_vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.cluster_lb_cidr #tfsec:ignore:AWS008
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.cluster_lb_cidr #tfsec:ignore:AWS008
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS009
  }
  tags = local.tags
}

resource "aws_alb_target_group" "statping_app" {
  name        = substr("${local.cluster_full_name}-target-group", 0, 32)
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.cluster_vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
  tags = local.tags
  lifecycle {
    create_before_destroy = true
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "http" {
  count             = var.cluster_enable_https ? 0 : 1
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP" #tfsec:ignore:AWS004
  default_action {
    target_group_arn = aws_alb_target_group.statping_app.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  count             = var.cluster_enable_https ? 1 : 0
  load_balancer_arn = aws_alb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = module.acm[0].this_acm_certificate_arn
  ssl_policy        = var.lb_listener_ssl_policy
  default_action {
    target_group_arn = aws_alb_target_group.statping_app.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "http_redirect" {
  count             = var.cluster_enable_https ? 1 : 0
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.statping_app.arn
    type             = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# add certificate
data "aws_route53_zone" "default" {
  count = var.cluster_enable_https ? 1 : 0
  name  = var.cluster_hosted_zone_name
}

module "acm" {
  count   = var.cluster_enable_https ? 1 : 0
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = var.statping_domain
  zone_id     = data.aws_route53_zone.default[0].zone_id

  tags = local.tags
  depends_on = [
    aws_route53_record.default
  ]
}

resource "aws_route53_record" "default" {
  count   = var.cluster_enable_https ? 1 : 0
  name    = var.statping_domain
  type    = "CNAME"
  ttl     = 60
  zone_id = data.aws_route53_zone.default[0].zone_id
  records = [
    aws_alb.main.dns_name
  ]
}
