param virtualNetworkName string
@description('Name of the Subnet')
param subnetName string

// Reference the existing virtual network in the module
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetworkName
}

// resource for subnets
resource subnets 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  name: subnetName
  parent: vnet
  properties: {
    addressPrefixes: [
      '10.0.0.0/24'
    ]
  }
}

// outputs for the subnets
output subnetId string = subnets.id
