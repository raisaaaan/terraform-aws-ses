data "aws_route53_zone" "domain" {
	name = var.use_domain
}

locals {
	domain = var.sub_domain.enable ? "${var.sub_domain.text}.${data.aws_route53_zone.domain.name}" : data.aws_route53_zone.domain.name
}

resource "aws_ses_domain_identity" "ses" {
	domain = local.domain
}

# create domain verification record
resource "aws_route53_record" "verification" {
	count = var.records_config.verification ? 1 : 0
	zone_id = data.aws_route53_zone.domain.id
	name = "_amazonses.${aws_ses_domain_identity.ses.domain}"
	type = "TXT"
	ttl = "300"
	records = [
		aws_ses_domain_identity.ses.verification_token
	]
	depends_on = [
		data.aws_route53_zone.domain,
		aws_ses_domain_identity.ses
	]
}

# check domain verification
resource "aws_ses_domain_identity_verification" "ses" {
	count = var.records_config.verification ? 1 : 0
	domain = aws_ses_domain_identity.ses.domain
	depends_on = [
		aws_route53_record.verification
	]
}

# dkim
resource "aws_ses_domain_dkim" "ses" {
	domain = aws_ses_domain_identity.ses.domain
}

# create dkim records
resource "aws_route53_record" "dkim" {
	# depends_onしてるとlength()使えないので固定値入れておく
	count = var.records_config.dkim ? 3 : 0
	zone_id = data.aws_route53_zone.domain.id
	name = "${element(aws_ses_domain_dkim.ses.dkim_tokens, count.index)}._domainkey.${aws_ses_domain_identity.ses.domain}"
	type = "CNAME"
	ttl = "300"
	records = [
		"${element(aws_ses_domain_dkim.ses.dkim_tokens, count.index)}.dkim.amazonses.com"
	]
	depends_on = [
		aws_ses_domain_dkim.ses
	]
}

# TXT record for SPF
resource "aws_route53_record" "txt" {
	count = var.records_config.txt ? 1 : 0
	zone_id = data.aws_route53_zone.domain.id
	name = aws_ses_domain_identity.ses.domain
	type = "TXT"
	ttl = "300"
	records = [
		"v=spf1 include:amazonses.com -all"
	]
	depends_on = [
		aws_ses_domain_identity.ses
	]
}

# TODO: 受信セットアップまだ