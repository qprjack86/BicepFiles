param namePrefix string
param location string 

param VirtualNetworkName string = '${namePrefix}-vnet'
param addressSpace string
param subnetName string = 'VMSubnet'

var firstOutput = split(addressSpace, '.' )
var mask1 = firstOutput[0]
var mask2 = firstOutput[1]

var sub1 = '${mask1}.${mask2}.10.0/24'

resource vnet_generic 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: VirtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: sub1
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
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

