variable "list_of_allowed_locations" {
  description = "List of allowed locations."
  type        = list(string)
}


variable "top-lz-mg" {
  description = "The LZ top management group ID"
  default = "mg-playtika-lz"
}