@description('Private Domain')
param domain string
param Name string
param ipv4Address string
param ttl int


// reference for existing priavte dns
resource privateDns 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: domain
}

resource rabbitmqdns 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: Name
  parent: privateDns
  properties: {
    ttl: ttl
    aRecords: [
      {
        ipv4Address: ipv4Address
      }
    ]
  }
}
