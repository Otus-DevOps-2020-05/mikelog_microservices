variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable subnet_id {
  description = "Subnet ID"
}

variable image_id {
  description = "Image ID"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}

variable private_key_path {
  description = "Path to private key used for provisioners"
}

variable docker-host_region {
  description = "App Region"
  default     = "ru-central1"
}

variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable service_account_key_file {
  description = "Path to auth ya cloud"
}
variable inst_cnt {
  description = "Count of instances"
  default     = "1"
}
