resource "azurerm_kubernetes_cluster" "muzi-aks" {
  name                = "muzi-aks"
  resource_group_name = azurerm_resource_group.muzi-rg.name
  location            = azurerm_resource_group.muzi-rg.location
  dns_prefix          = local.dns-prefix

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.muzi-sn[0].id
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  tags = {
    Environment = var.environment
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.muzi-aks.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.muzi-aks.kube_config_raw
}