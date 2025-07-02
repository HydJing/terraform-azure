# defines the variables metadata, like recipe book,  'Salt' (a string), 'Water Quantity' (a number, default 2 cups), and 'Spicy Level' (a number between 1 and 5)
# Define the variables in your variables.tf or pass them via CLI/environment variables
variable "local_ssh_username" {
  description = "Your local Windows user folder name for SSH config." # A clear description for users of this variable.
  type        = string                                                # Specifies that the variable expects a string value.
  sensitive   = false                                                 # Mark as sensitive if it could contain PII or be a security risk
}

variable "host_os" {
  type    = string
  default = "windows"
}