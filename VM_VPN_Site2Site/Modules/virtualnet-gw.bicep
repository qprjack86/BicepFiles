param virtualNetworkGatewayName string = '${namePrefix}_VNG' 
param rgName string 
param location string 
param sku string = 'Basic'
param namePrefix string
 
@allowed([
  'Vpn'
  'ExpressRoute'
])
param gatewayType string = 'Vpn'
 
@allowed([
  'RouteBased'
  'PolicyBased'
])
param vpnType string = 'RouteBased'
param VirtualNetworkName string = '${namePrefix}-vnet' 
param SubnetName string = 'GatewaySubnet'
param PublicIpAddressName string = '${namePrefix}-gw-pip'
param enableBGP bool = false

resource GWPublicAddress 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name:PublicIpAddressName
  location:location
  properties: {
    publicIPAllocationMethod:'Dynamic'
  }
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2022-11-01' = {
  name: virtualNetworkGatewayName
  location:location
  properties:{
    gatewayType:gatewayType
    ipConfigurations: [
      {
        name:'default'
        properties:{
          privateIPAllocationMethod:'Dynamic'
          subnet:{
            id: resourceId(rgName, 'Microsoft.Network/virtualNetworks/subnets', VirtualNetworkName, SubnetName)
          }
          publicIPAddress: {
            id: resourceId(rgName, 'Microsoft.Network/publicIPAddresses', PublicIpAddressName)
          }
        }
      }
    ]
    vpnType: vpnType
    enableBgp:enableBGP
    sku:{
      name:sku
      tier:sku
    }
  }
  dependsOn: [
   GWPublicAddress
  ]
}
output vngid string = virtualNetworkGateway.id 
