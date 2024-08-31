param Name string
param Location string
param subnetId string
param privateIPAllocationMethod string

resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: Name
  location: Location
  properties: {
    ipConfigurations: [
      {
        name: Name
        properties: {
         subnet: {
          id: subnetId
         } 
         privateIPAllocationMethod: privateIPAllocationMethod
        }
      }
    ]
  }
}

output nicId string = nic.id
