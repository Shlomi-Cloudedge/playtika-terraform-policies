data "azurerm_management_group" "mg-playtika-lz" {
  name = "mg-playtika-lz"
}

data "azurerm_management_group" "mg-business-units" {
  name = "mg-business-units-playtika-lz"
}

data "azurerm_management_group" "mg-playground-playtika-lz" {
  name = "mg-playground-playtika-lz"
}

output "playground_mg_id" {
  value = data.azurerm_management_group.mg-playground-playtika-lz.id
}