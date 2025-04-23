module "catalog" {
  source = "../modules/catalogs"
  catalog_name        = var.vcd_catalog_name
  vapp_template_name  = var.vcd_vapp_template_name
}

