output "domain" {
	value = aws_ses_domain_identity.ses.domain
}

output "verification_token" {
	value = aws_ses_domain_identity.ses.verification_token
}

output "dkim_tokens" {
	value = aws_ses_domain_dkim.ses.dkim_tokens
}