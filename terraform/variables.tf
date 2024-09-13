variable "bq_dataset_name" {
    description = "Bigquery api dataset"
    default = "api_rand_dataset"
}

variable "project_name" {
    description = "GCP project name"
    default = "dwh-terraform-gcp"
}

variable "bucket_name" {
    description = "GCP bucket name"
    default = "dwh-terraform-gcp-api"
}

variable "location" {
    description = "GCP location name"
    default = "EU"
}
variable "credentials" {
    description = "GCP creds"
    default = "D:\\projekty_z_programowania\\api_de_project\\terraform\\keys\\key.json"
}