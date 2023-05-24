@description('Location to deploy all resources. Leave this value as-is to inherit the location from the parent resource group.')
param location string = resourceGroup().location

@description('New  VNet Name')
param virtualNetworkName string

@description('VNet address prefix')
param virtualNetworkAddressPrefix string

@description('New subnet Name')
param subnetName string 

@description('Subnet address prefix')
param subnetAddressPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01'=  {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]

  }
}

output vnetId string = vnet.id
output name string = vnet.name
