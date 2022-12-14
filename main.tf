data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_virtual_network" "main_vcn" {
  cidr_block     = "10.10.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "VCN"
  dns_label      = "mainvcn"
}

resource "oci_core_internet_gateway" "main_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "mainIG"
  vcn_id         = oci_core_virtual_network.main_vcn.id
  depends_on     = [oci_core_virtual_network.main_vcn]
}

resource "oci_core_security_list" "main_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "mainSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "80"
      min = "80"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "443"
      min = "443"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "6443"
      min = "6443"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "10.10.0.0/16"

    tcp_options {
      max = "10250"
      min = "10250"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "3306"
      min = "3306"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "5432"
      min = "5432"
    }
  }
}

resource "oci_core_route_table" "main_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.main_vcn.id
  display_name   = "mainRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main_internet_gateway.id
  }
  depends_on     = [oci_core_internet_gateway.main_internet_gateway]
}

resource "oci_core_subnet" "main_subnet" {
  cidr_block        = "10.10.1.0/24"
  display_name      = "mainSubnet"
  dns_label         = "mainsubnet"
  security_list_ids = [oci_core_security_list.main_security_list.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.main_vcn.id
  route_table_id    = oci_core_route_table.main_route_table.id
  dhcp_options_id   = oci_core_virtual_network.main_vcn.default_dhcp_options_id

  depends_on = [
    oci_core_virtual_network.main_vcn, oci_core_security_list.main_security_list, oci_core_route_table.main_route_table
  ]
}