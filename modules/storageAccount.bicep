param Name string
param Location string
param Kind string
param SKU_Name string
param accessTier string

// resource for stoage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: Name
  location: Location
  kind: Kind
  sku: {
    name: SKU_Name
  }
  properties: {
    accessTier: accessTier
  }
}

// output for stoage account
output storageAccountId string = storageAccount.id
output storageAccountUri string = storageAccount.properties.primaryEndpoints.blob
