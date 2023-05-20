//Parameters and Variables
param location string 
param namePrefix string
param storageAccountName string = '${namePrefix}storageacc'
param subnetID string
param storageID string
param vnetName string
var privateDnsNameStorage_var = 'privatelink.file.${environment().suffixes.storage}'

//Create Private link
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: '${storageAccountName}-plink'
  location: location
  properties:{
    subnet:{
      id:subnetID
    }
privateLinkServiceConnections:[
  {
    name:'pl-connection'
  properties:{
    privateLinkServiceId:storageID
    groupIds:[
    'file'
    ]
  }
  }
]
  }
}

//Create Private Zone DNS
resource privateDnsNameStorage 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsNameStorage_var
  location: 'global'
  tags: {}
  properties: {}
}
resource privateDnsNameStorage_vnetName 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsNameStorage
  name: vnetName
  location: 'global'
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
    registrationEnabled: false
  }
}
resource storageAccountPrivateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-02-01' = {
 parent:privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsNameStorage.id
        }
      }
    ]
  }
}
