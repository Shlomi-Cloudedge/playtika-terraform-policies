#_________________________HUB AND SPOKE POLICY_____________________________


############################# Not yet deployed waiting for the Hub VNet #############################

# resource "azurerm_policy_definition" "hub-and-spoke-test-policy" {
#   name         = "hub-and-spoke-test-policy"
#   policy_type  = "Custom"
#   mode         = "All"
#   display_name = "hub-and-spoke-test-policy"

#   metadata = file("./policy-defenitions/allow-peering-only-to-hubs/azurepolicy.json")

#   parameters = file("./policy-defenitions/allow-peering-only-to-hubs/azurepolicy.parameters.json")

#   policy_rule = file("./policy-defenitions/allow-peering-only-to-hubs/azurepolicy.rules.json")

# }

# data "azurerm_virtual_network" "hub-vnet" {
#   name                = "HUB"
#   resource_group_name = "rg_vnet_peering_test"
# }

# resource "azurerm_subscription_policy_assignment" "hub-and-spoke-test-policy-assignment" {
#   name                 = "hub-and-spoke-test-policy-assignment"
#   subscription_id      = data.azurerm_subscription.current.id
#   policy_definition_id = azurerm_policy_definition.hub-and-spoke-test-policy.id

#   parameters = <<PARAMETERS
#   {
#     "allowedVNets": {
#       "value": [
#         "${data.azurerm_virtual_network.hub-vnet.id}"
#       ]
#     },
#     "effect": {
#       "value": "Audit"
#     }
#   }
#   PARAMETERS
# }

#_________________________Allowed Location Policy_____________________________

############################# Not yet deployed waiting for playtika's list of allowed location#############################

# resource "azurerm_management_group_policy_assignment" "allowed-regions" {
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
#   management_group_id = "mg-playtika-lz"
#   not_scopes = ["mg-playground-playtika-lz"]
#   name                 = "Allowed Locations for resources creation"

#   parameters = <<PARAMETERS
#   {
#     "listOfAllowedLocations": {
#       "value": [
#         "westEurope",
#         "northeurope",
#         "israelCentral"
#       ]
#     },
#   }
#   PARAMETERS
# }

#_________________________Allowed Resource types Policy_____________________________

############################# Not yet deployed waiting for playtika's list of resources types#############################

# resource "azurerm_management_group_policy_assignment" "allowed-resource-types" {
#   name                 = "allowed-resource-types"
#   management_group_id = "mg-playtika-lz"
#   not_scopes = ["mg-playground-playtika-lz"]
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c"

#   parameters = <<PARAMETERS
#   {
#     "listOfResourceTypesAllowed": {
#       "value": [
        
#       ]
#     },
#     "effect": {
#       "value": "Audit"
#     }
#   }
#   PARAMETERS
# }

#_________________________Require Tags on resources_____________________________

resource "azurerm_policy_definition" "deny-resources-without-required-tags" {
  name = "deny-resources-without-required-tags"
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  mode = "All"
  display_name = "deny-resources-without-required-tags"
  policy_type = "Custom"
  metadata = file("./policy-defenitions/deny-resources-without-tags/azurepolicy.json")
  policy_rule = file("./policy-defenitions/deny-resources-without-tags/azurepolicy.rules.json")
  parameters = file("./policy-defenitions/deny-resources-without-tags/azurepolicy.parameters.json")
}


resource "azurerm_management_group_policy_assignment" "deny-resources-without-required-tags-assignment" {
  name = "deny-tags"
  display_name = "deny-resources-without-required-tags-assignment"
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  policy_definition_id = azurerm_policy_definition.deny-resources-without-required-tags.id
  parameters = <<PARAMETERS
    {
      "environment": {
       "value": "environment"
     },
     "project": {
       "value": "project"
     },
     "owner": {
       "value": "owner"
     },
     "createdBy": {
       "value": "createdBy"
     },
     "location": {
       "value": "location"
     },
     "TimeStamp": {
       "value": "TimeStamp"
     },
      "effect": {
       "value": "Deny"
     }
    }
    PARAMETERS
}

#_________________________Audit VMs that do not use managed disks_____________________________


############################# Need to ask if needed #############################

# resource "azurerm_management_group_policy_assignment" "audit-vms-that-do-not-use-managed-disks" {
#   name = "audit-vms-that-do-not-use-managed-disks"
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
#   management_group_id = "mg-playtika-lz" 
# }

#_________________________Audit unattached managed disks_____________________________

resource "azurerm_policy_definition" "audit-unattached-managed-disks" {
  name = "audit-unattached-managed-disks"
  mode = "All"
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  display_name = "audit-unattached-managed-disks"
  policy_type = "Custom"
  policy_rule = file("./policy-defenitions/audit-unattached-managed-disks/azurepolicy.rules.json")
  parameters = file("./policy-defenitions/audit-unattached-managed-disks/azurepolicy.parameters.json")
}

resource "azurerm_management_group_policy_assignment" "audit-unattached-managed-disks-assignment" {
  name = "audit-disks"
  display_name = "audit-unattached-managed-disks-assignment"
  policy_definition_id = azurerm_policy_definition.audit-unattached-managed-disks.id
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
}

# #_________________________Enforce Diagnostic setting on Subscriptions_____________________________

############################# Need to deploy the LZ log analytics before #############################

# # resource "azurerm_policy_definition" "set-diagnostic-setting-on-subscriptions" {
# #   name = "set-diagnostic-setting-on-subscriptions"
# #   mode = "All"
# #   display_name = "set-diagnostic-setting-on-subscriptions"
# #   policy_type = "Custom"
# #   metadata = file("./policy-defenitions/set-diagnostic-settings-on-subscriptions/azurepolicy.json")
# #   policy_rule = file("./policy-defenitions/set-diagnostic-settings-on-subscriptions/azurepolicy.rules.json")
# #   parameters = file("./policy-defenitions/set-diagnostic-settings-on-subscriptions/azurepolicy.parameters.json")
# # }

# # resource "azurerm_subscription_policy_assignment" "set-diagnostic-setting-on-subscriptions-assignment" {
# #   name = "set-diagnostic-setting-on-subscriptions-assignment"
# #   policy_definition_id = azurerm_policy_definition.set-diagnostic-setting-on-subscriptions.id
# #   subscription_id = data.azurerm_subscription.current.id
# # }

# #_________________________Network interfaces should not have public IPs_____________________________

resource "azurerm_management_group_policy_assignment" "deny-network-interface-public-ip-assignment" {
  name = "deny-nic-pip"
  display_name = "deny-network-interface-public-ip-assignment"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
  management_group_id = data.azurerm_management_group.mg-business-units.id
}

# #_________________________Deny NSG allowing RDP and SSH from any source_____________________________

resource "azurerm_policy_definition" "deny-nsg-allow-rdp-ssh-any" {
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  name = "deny-nsg-allow-rdp-ssh-any"
  mode = "All"
  display_name = "deny-nsg-allow-rdp-ssh-any"
  policy_type = "Custom"
  metadata = file("./policy-defenitions/deny-nsg-allowing-ssh-rdp-any/azurepolicy.json")
  policy_rule = file("./policy-defenitions/deny-nsg-allowing-ssh-rdp-any/azurepolicy.rules.json")
  parameters = file("./policy-defenitions/deny-nsg-allowing-ssh-rdp-any/azurepolicy.parameters.json")
}

resource "azurerm_management_group_policy_assignment" "deny-nsg-allow-rdp-ssh-any-assignment" {
  name = "deny-nsg-any"
  display_name = "deny-nsg-allow-rdp-ssh-any-assignment"
  policy_definition_id = azurerm_policy_definition.deny-nsg-allow-rdp-ssh-any.id
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  not_scopes = [ data.azurerm_management_group.mg-playground-playtika-lz.id ]

  parameters = <<PARAMETERS
    {
      "effect": {
       "value": "Deny"
     }
    }
    PARAMETERS
}

# #_________________________Secure transfer to storage accounts should be enabled_____________________________


resource "azurerm_management_group_policy_assignment" "secure-transfer-to-storage-accounts-assignment" {
  name = "secure-storage"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  }


# #_________________________Storage Accounts should not allow public blobs_____________________________

resource "azurerm_policy_definition" "deny-pulic-blobs-exlude-tag" {
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  name = "deny-pulic-blobs-exlude-tag"
  mode = "Indexed"
  display_name = "deny-pulic-blobs-exlude-tag"
  policy_type = "Custom"
  metadata = file("./policy-defenitions/deny-public-blobs/azurepolicy.json")
  policy_rule = file("./policy-defenitions/deny-public-blobs/azurepolicy.rules.json")
  parameters = file("./policy-defenitions/deny-public-blobs/azurepolicy.parameters.json")
}

resource "azurerm_management_group_policy_assignment" "deny-pulic-blobs-exlude-tag-assignment" {
  name = "deny-pulic-blobs-tag"
  display_name = "deny-pulic-blobs-exlude-tag-assignment"
  policy_definition_id = azurerm_policy_definition.deny-pulic-blobs-exlude-tag.id
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  not_scopes = [data.azurerm_management_group.mg-playground-playtika-lz.id]
  parameters = <<PARAMETERS
    {
      "effect": {
      "value": "Deny"
     },
     "public": {
      "value": "DataSecurity"
     }
    }
  PARAMETERS
}

#   #_________________________Automation account variables should be encrypted_____________________________

  resource "azurerm_management_group_policy_assignment" "audit-automation-account-variables-encryption-assignment" {
  name = "auto-vars-encryption"
  display_name = "audit-automation-account-variables-encryption-assignment"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/3657f5a0-770e-44a3-b44e-9431ba1e9735"
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id

  parameters = <<PARAMETERS
    {
      "effect": {
    "value": "Audit"
      }
    }
    PARAMETERS
  }


#_________________________Key vault Certificates should not expire within the specified number of days_____________________________

  resource "azurerm_management_group_policy_assignment" "key-vault-certificates-expiration-audit-45day" {
  name = "kv-certs-45"
  display_name = "key-vault-certificates-expiration-audit-45day"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f772fb64-8e40-40ad-87bc-7706e1949427"
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id

  parameters = <<PARAMETERS
    {
      "effect": {
        "value": "Audit"
      },
      "daysToExpire":{
        "value": 45
      }
    }
    PARAMETERS
  }

#_________________________Defender for cloud enforcement_____________________________

# Defender for cloud will be enabled on these plans :
# App services , Databases , storage , key vaults , resource manager

  resource "azurerm_management_group_policy_assignment" "deploy-defender-for-cloud-plans" {
  name = "defender-for-cloud"
  display_name = "deploy-defender-for-cloud-plans"
  policy_definition_id = "/providers/Microsoft.Management/managementGroups/mg-playtika-lz/providers/Microsoft.Authorization/policySetDefinitions/fcc07614bac84e3a83e6d92b"
  management_group_id = data.azurerm_management_group.mg-playtika-lz.id
  location = "westEurope"
  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_role_assignment" "managed-identity-role-assignment_owner" {
  scope = data.azurerm_management_group.mg-playtika-lz.id
  principal_id = azurerm_management_group_policy_assignment.deploy-defender-for-cloud-plans.identity[0].principal_id
  role_definition_name = "Owner"
}

resource "azurerm_role_assignment" "managed-identity-role-assignment-sec-admin" {
  scope = data.azurerm_management_group.mg-playtika-lz.id
  principal_id = azurerm_management_group_policy_assignment.deploy-defender-for-cloud-plans.identity[0].principal_id
  role_definition_name = "Security Admin"
}

