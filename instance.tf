resource "oci_core_instance" "k3s_main" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "k3s-main"
  shape               = var.arm_instance_shape

  // 2 cpu, 12 ram
  shape_config {
    ocpus = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.main_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "k3s-main"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.arm_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

resource "oci_core_instance" "k3s_postgres" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "k3s-postgres"
  shape               = var.amd_instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.main_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "k3s-postgres"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.amd_ubuntu_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

resource "oci_core_instance" "k3s_arm_server" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "k3s-arm-server"
  shape               = var.arm_instance_shape

  // 2 cpu, 12 ram
  shape_config {
    ocpus = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.main_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "k3s-arm-server"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.arm_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

resource "oci_core_instance" "k3s_amd_agent" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = "k3s-amd-agent"
  shape               = var.amd_instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.main_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "k3s-amd-agent"
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.amd_ubuntu_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}