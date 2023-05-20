param namePrefix string
param location string
param VirtualNetworkName string = '${namePrefix}-vnet'
param subnetName string = 'VMSubnet'

resource vnet_generic 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: VirtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.2.0/24'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.2.0/25'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
       }
    {
      name:'GatewaySubnet'
      properties: {
        addressPrefix: '10.0.2.128/28'
      }
    }
      ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
  
}

output vnetId string = vnet_generic.id
output subnetId string = '${vnet_generic.id}/subnets/${subnetName}'
output subnetName string = subnetName
output vnetName string = VirtualNetworkName
