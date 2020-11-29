variable "use_domain" {
	type = string
	description = "use domain"
}

variable "sub_domain" {
	type = object({
		enable = bool
		text = string
	})
	description = "sub domain setting"
	default = {
		enable = false
		text = ""
	}
	validation {
		condition =  (var.sub_domain.enable == false) || (var.sub_domain.enable && length(var.sub_domain.text) > 0)
		error_message = "Subdomain text is empty."
	}
}

variable "records_config" {
	type = object({
		verification = bool
		dkim = bool
		txt = bool
	})
	description = "create record config"
	default = {
		verification = true
		dkim = true
		txt = true
	}
}
