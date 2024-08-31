param Name string
param Location string
param vmSize string //'Standard_B2ms'
param nicId string
param adminUsername string
@secure()
param adminPassword string
param customData string
param disablePasswordAuthentication bool // default false
param bootDiagnosticsEnabled bool
param storageUri string

resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: Name
  location: Location
  properties: {
    hardwareProfile: {
      vmSize: vmSize 
    }
    storageProfile: {
      osDisk: {
        name: Name
        createOption: 'FromImage'
      }
      imageReference: {
        // https://learn.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage
        // Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest' 
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
        }
      ]  
    }
    osProfile: {
      computerName: Name
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: customData
      linuxConfiguration: {
        disablePasswordAuthentication: disablePasswordAuthentication
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: bootDiagnosticsEnabled
        storageUri: storageUri
      }
    }
  }
}
