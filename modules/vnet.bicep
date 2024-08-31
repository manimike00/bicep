@description('Name of the virtual Network')
param virtualNetworkName string
@description('Name of the subnet')
param Location string

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetworkName
  location: Location
  properties: {
    addressSpace: {
       addressPrefixes: [
        '10.0.0.0/16'
       ]
    }
  }
}

output virtualNetworkName string = virtualNetworkName
output virtualNetworkId string = vnet.id
