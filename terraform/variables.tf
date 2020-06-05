variable "default_role" {
  default = "ci"
}

variable "management_role" {
  default = "ci"
}

variable "accounts" {
  type = map(
    object({
      account_id                 = string
      a_name_record              = string
      allowed_access_app_secret = list(string)
      is_production              = number
    })
  )
}
