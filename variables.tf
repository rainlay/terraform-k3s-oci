variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "region" {
}

variable "compartment_ocid" {
}

// VM 用的 ssh key 
variable "ssh_public_key" {
}

provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

variable "arm_instance_shape" {
  default = "VM.Standard.A1.Flex" # Or VM.Standard.E2.1.Micro
}

variable "amd_instance_shape" {
  default = "VM.Standard.E2.1.Micro"
}

# See https://docs.oracle.com/iaas/images/
data "oci_core_images" "arm_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = var.arm_instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_core_images" "amd_ubuntu_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = var.amd_instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  filter {
    name = "display_name"
    values = ["^Canonical-Ubuntu-22.04-([\\.0-9-]+)$"]
    regex = true
  }
}

output "ubuntu-22-04-latest-name" {
  value = data.oci_core_images.amd_ubuntu_images.images.0.display_name
}
output "ubuntu-22-04-latest-id" {
  value = data.oci_core_images.amd_ubuntu_images.images.0.id
}