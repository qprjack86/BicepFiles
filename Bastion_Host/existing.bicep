@description('Location of Resources')
param location string= resourceGroup().location

@description('Naming prefix for all deployed resources.')
param bstPrefix string

@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExisting string = 'existing'

@description('Name of the Azure virtual network, required if utilizing and existing VNET. If no name is provided the default name will be the Resource Group Name as the Prefix and \'-VNET\' as the suffix')
param vnetName string = 'bst_vnet'

@description('Resource Group containing the existing virtual network, leave blank if a new VNET is being utilized')
param vnetResourceGroup string = 'bst_rg'

@description('Virtual Network Address prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

//param subnet1Name string ='VMSubnet'
param subnet1Name string ='AzureBastionSubnet'

param bstName string = ''



var vnetNamevar = ((vnetName == '') ? '${bstPrefix}-VNET' : vnetName)
var bstNamevar = ((bstName == '') ? '${bstPrefix}-bst' : bstName)
var bstPIPNamevar = '${bstPrefix}-bst-PIP' 
var bstsubArray = split(vnetAddressPrefix, '.' )
var mask1 = bstsubArray[0]
var mask2 = bstsubArray[1]
var sub1 = '${mask1}.${mask2}.123.0/26'
var subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name))



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
        name: subnet1Name
        properties: {
          addressPrefix: sub1
        }
      }
    ]
  }
}
resource BastionSub 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = if (vnetNewOrExisting == 'existing') {
  name: subnet1Name
  parent:virtualNetwork
  properties:{
    addressPrefix:sub1

}
}

resource azureBastion 'Microsoft.Network/bastionHosts@2022-11-01' =  {
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
             id: subnet1Id
           }
         }
       }
    ]
  }
}
resource bstPIP 'Microsoft.Network/publicIPAddresses@2022-11-01'=  {
  name: bstPIPNamevar
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  } 
}
