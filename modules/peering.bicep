param Name string
param virtualNetworkName string
param remoteVnet string

// Reference the existing virtual network in the module
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetworkName
}

// resource for vnet perring
resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: Name
  parent: vnet
  properties: {
    remoteVirtualNetwork: {
      id: remoteVnet
    }
  }
}
