param location string= resourceGroup().location
param addressSpace string
param vnetName string

var firstOutput = split(addressSpace, '.' )
var mask1 = firstOutput[0]
var mask2 = firstOutput[1]

var sub4 = '${mask1}.${mask2}.123.0/24'

var bstPIPName = '${vnetName}-bst-pip'

var bstName = '${vnetName}-bst'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    subnets: [
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: sub4
        }
      }
      
    ]
  }
}
resource bstPIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: bstPIPName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
resource azureBastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: bstName
  location: location
  properties: {
    ipConfigurations: [
       {
         name: 'ipConf'
         properties: {
           publicIPAddress: {
             id: bstPIP.id
           }
           subnet: {
             id: '${virtualNetwork.id}/subnets/AzureBastionSubnet'
           }
         }
       }
    ]
  }
}