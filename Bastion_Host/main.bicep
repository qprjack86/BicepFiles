@description('Location of Resources')
param location string= resourceGroup().location

@description('Naming prefix for all deployed resources.')
param bstPrefix string

@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExisting string = 'new'

@description('Name of the Azure virtual network, required if utilizing and existing VNET. If no name is provided the default name will be the Resource Group Name as the Prefix and \'-VNET\' as the suffix')
param vnetName string = ''

@description('Resource Group containing the existing virtual network, leave blank if a new VNET is being utilized')
param vnetResourceGroup string = ''

@description('Virtual Network Address prefix')
param vnetAddressPrefix string 

param subnet1Name string ='VMSubnet'
param subnet2Name string ='AzureBastionSubnet'

@description('Identify whether to use a new or existing bastion')
param bstNewOrExisting string = 'new'
param bstName string = ''



var vnetNamevar = ((vnetName == '') ? '${bstPrefix}-VNET' : vnetName)
var bstNamevar = ((bstName == '') ? '${bstPrefix}-bst' : bstName)
var bstPIPNamevar = '${bstPrefix}-bst-PIP' 
var firstOutput = split(vnetAddressPrefix, '.' )
var mask1 = firstOutput[0]
var mask2 = firstOutput[1]
var sub1 = '${mask1}.${mask2}.10.0/24'
var sub2 = '${mask1}.${mask2}.123.0/24'
//var subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name))
var subnet2Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name))
//var bstId = ((bstNewOrExisting == 'new') ? resourceId('Microsoft.Network/bastionHosts', bstNamevar) : resourceId(vnetResourceGroup, 'Microsoft.Network/bastionHosts', bstNamevar))


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = if (vnetNewOrExisting == 'new') {
  name: vnetNamevar
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet2Name
        properties: {
          addressPrefix: sub2
        }
      }
      {
        name:subnet1Name
        properties:{
          addressPrefix:sub1
        }
      }
      
      
    ]
  }
}
resource azureBastion 'Microsoft.Network/bastionHosts@2022-11-01' = if (bstNewOrExisting == 'new') {
  name: bstNamevar
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
             id: subnet2Id
           }
         }
       }
    ]
  }
dependsOn:[
  virtualNetwork
]
}
resource bstPIP 'Microsoft.Network/publicIPAddresses@2022-11-01'= if (bstNewOrExisting == 'new') {
  name: bstPIPNamevar
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
 
}
