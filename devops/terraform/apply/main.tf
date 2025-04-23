terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.11.0"
    }
  }
}

# Configure the VCD Provider
provider "vcd" {
  user = "none" 
  password  = "none"
  org = var.vcd_org
  vdc = var.vcd_vdc
  url = var.vcd_url
  auth_type = "api_token"
  api_token = var.vcd_token
}

# Data source
data "vcd_vdc_group" "main" {
  name = var.vcd_vdc_group
}

# Existing edgegateway declaration
data "vcd_nsxt_edgegateway" "existing" {
  owner_id = data.vcd_vdc_group.main.id
  name = var.vcd_nsxt_edgegateway
}

