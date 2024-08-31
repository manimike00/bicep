@description('Rpivate Domain')
param priavteDns string
param Name string
param registrationEnabled bool
param virtualNetworkId string

resource privateDns 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: priavteDns
}

resource vnetpvtdnslink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: Name
  location: 'global'
  parent: privateDns
  properties: {
    registrationEnabled: registrationEnabled
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}
