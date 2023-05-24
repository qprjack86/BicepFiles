@description('Location of resources')
param location string = resourceGroup().location

@description('Name of the VNET to add a subnet to')
param existingVNETName string

@description('Name of the subnet to add')
param newSubnetName string = 'AzureBastionSubnet'

@description('Address space of the subnet to add')
param newSubnetAddressPrefix string

@description('Public IP Name of Bastion')
var bstPIPName = '${existingVNETName}-bst-pip'

@description('Name of Bastion Host')
var bstName = '${existingVNETName}-bst'

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
   name: existingVNETName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01' = {
  parent: vnet
  name: newSubnetName
  properties: {
    addressPrefix: newSubnetAddressPrefix
  }
}

resource bstPIP 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: bstPIPName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
resource azureBastion 'Microsoft.Network/bastionHosts@2022-11-01' = {
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
             id: '${vnet.id}/subnets/AzureBastionSubnet'
           }
         }
       }
    ]
  }
}
