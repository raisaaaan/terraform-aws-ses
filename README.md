# terraform-aws-ses
Terraform module to create send-only SES resources on AWS

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | ~> 2.56 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.56 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| records\_config | create record config | <pre>object({<br>  verification = bool<br>  dkim = bool<br>  txt = bool<br>})</pre> | <pre>{<br>  "dkim": true,<br>  "txt": true,<br>  "verification": true<br>}</pre> | no |
| sub\_domain | sub domain setting | <pre>object({<br>  enable = bool<br>  text = string<br>})</pre> | <pre>{<br>  "enable": false,<br>  "text": ""<br>}</pre> | no |
| use\_domain | use domain | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dkim\_tokens | n/a |
| domain | n/a |
| verification\_token | n/a |
