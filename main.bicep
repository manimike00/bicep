@description('Name of the Service')
param Name string
@description('Name of the virtual Network')
param virtualNetworkName string
@description('Name of the subnet')
param Location string = resourceGroup().location
param remoteVnetName  string
param remoteVnet  string
param adminUsername string
@secure()
param adminPassword string
param customData string
param priavteDns string
param BlobPriavteDns string
param bootdiagonticsStoageAccount string

// Virtual Network Module
module vnet 'modules/vnet.bicep' = {
  name: virtualNetworkName
  params: {
    virtualNetworkName: virtualNetworkName
    Location: Location
  }
}

// Subnet Module
module subnet 'modules/subnets.bicep' = {
  name: Name
  params: {
    subnetName: Name
    virtualNetworkName: vnet.outputs.virtualNetworkName
  }
}

// Spoke to Hub vnet peering
module spoketohub 'modules/peering.bicep' = {
  name: 'spoketohub'
  params: {
    Name: 'spoketohub'
    remoteVnet: remoteVnet
    virtualNetworkName: vnet.outputs.virtualNetworkName
  }
}

// Hub to spoke vnet peering
module hubtospoke 'modules/peering.bicep' = {
  name: 'hubtospoke'
  params: {
    Name: 'hubtospoke'
    remoteVnet: vnet.outputs.virtualNetworkId
    virtualNetworkName: remoteVnetName
  }
}

// Spoke Virtual Network linking with private dns
module privateDnsVnetlink 'modules/privateDnsVnetLink.bicep' = {
  name: 'spokevnet'
  params: {
    Name: 'spokevnet'
    priavteDns: priavteDns
    registrationEnabled: false
    virtualNetworkId: vnet.outputs.virtualNetworkId
  }
}

// Spoke Virtual Network linking with blob private dns
module blobprivateDnsVnetlink 'modules/privateDnsVnetLink.bicep' = {
  name: 'blobspokevnet'
  params: {
    Name: 'blobspokevnet'
    priavteDns: BlobPriavteDns
    registrationEnabled: false
    virtualNetworkId: vnet.outputs.virtualNetworkId
  }
}

// Stroage account for boot diagonstics logs
resource bootdiagonticsSA 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: bootdiagonticsStoageAccount
}
// module bootdiagonticsSA 'modules/storageAccount.bicep' = {
//   name: 'bootdiagonticssa'
//   params: {
//     Name: 'bootdiagonticssa'
//     Location: Location
//     Kind: 'StorageV2'
//     accessTier: 'Hot'
//     SKU_Name: 'Standard_LRS'
//   }
// }




// Network interface for rabbitmq virtual Machine
module nic 'modules/nic.bicep' = {
  name: 'rabbitmq-nic'
  params: {
    Name: 'rabbitmq'
    Location: Location
    subnetId: subnet.outputs.subnetId
    privateIPAllocationMethod: 'Dynamic'
  }
}

// rabbitmq virtual Machine
module rabbitmq 'modules/virtualMachine.bicep' = {
  name: 'rabbitmq-vm'
  params: {
    Name: 'rabbitmq.rapyder.co.in'
    adminUsername: adminUsername
    adminPassword: adminPassword
    customData: customData
    disablePasswordAuthentication: false
    Location: Location
    nicId: nic.outputs.nicId
    vmSize: 'Standard_B2ms'
    bootDiagnosticsEnabled: true
    storageUri: bootdiagonticsSA.properties.primaryEndpoints.blob
    // storageUri: bootdiagonticsSA.outputs.storageAccountUri
  }
}

// rabbitmq domain a record
module domain 'modules/privateDnsARecord.bicep' = {
  name: 'rabbitmq-a-record'
  params: {
    Name: 'rabbitmq'
    ttl: 60
    domain: priavteDns
    ipv4Address: nic.outputs.nicPrivateIp
  }
}
