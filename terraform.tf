# Terraform configuration for provisioning a Google Cloud Platform (GCP) virtual machine using Cloud Build pipeline method

# Configure the GCP provider
provider "google" {
  credentials = file("tera.json")  # Path to your JSON key file
  project     = "latest-414811"     # Your GCP project ID
  region      = "us-central1-a"     # Your desired region
}

# Define variables
variable "machine_type" {
  default = "n1-standard-1" # Modify as needed
}

variable "disk_size_gb" {
  default = 20 # Modify as needed
}

variable "image" {
  default = "debian-cloud/debian-10" # Modify as needed
}

variable "network" {
  default = "default" # Modify as needed
}

# Define resources
resource "google_compute_instance" "vm_instance" {
  name         = "example-instance"
  machine_type = var.machine_type
  zone         = "us-central1-a" # Your desired zone
  
  boot_disk {
    initialize_params {
      size = var.disk_size_gb
      image = var.image
    }
  }
  
  network_interface {
    network = var.network
    access_config {}
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && sudo service apache2 start" # Example startup script, modify as needed
}

# Output the IP address of the provisioned instance for reference
output "vm_instance_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.address
}
