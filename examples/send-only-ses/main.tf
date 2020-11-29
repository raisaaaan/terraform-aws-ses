provider "aws" {
	region = "ap-northeast-1"
}

module "send-only-ses" {
	source = "../../"
	use_domain = "example.com"
	sub_domain = {
		enable = true
		text = "ses"
	}
	records_config = {
		verification = true
		dkim = true
		txt = true
	}
}

output "domain" {
	value = module.send-only-ses.domain
}

output "verification_token" {
	value = module.send-only-ses.verification_token
}

output "dkim_tokens" {
	value = module.send-only-ses.dkim_tokens
}