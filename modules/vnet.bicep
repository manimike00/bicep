@description('Name of the virtual Network')
param virtualNetworkName string
@description('Location of the virtula Network')
param Location string


// resource for virtual network
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

// outputs for virtual networks
output virtualNetworkName string = virtualNetworkName
output virtualNetworkId string = vnet.id
