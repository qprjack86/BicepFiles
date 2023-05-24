targetScope = 'subscription'

param rg1Name string = 'VSL_RG'
param location string = deployment().location
param namePrefix string ='VSL'
param vmNames array = [
  'srv-dc-az'
  'srv-app-az'
]
//Password for VM's
@minLength(12)
@secure()
param adminPassword string


resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' ={
  name:rg1Name
  location:location
  
}

module vnet 'Modules/vnet-generic.bicep' ={
name:'${rg1Name}-vnet'
scope:(resourceGroup(rg1Name))
params:{
namePrefix:namePrefix
location:location
}
dependsOn:[
  rg
]
}

module vng 'Modules/virtualnet-gw.bicep' = {
  name:'${rg1Name}-vngw'
  scope:(resourceGroup(rg1Name))
  params:{
    rgName:rg1Name
    location:location
    namePrefix:namePrefix

    }
dependsOn:[
  vnet
]
}  
module lgw 'Modules/localnetgw-generic.bicep' = {
  name: '${rg1Name}-lngw'
  scope:(resourceGroup(rg1Name))
  params:{
    localNetworkGatewayName:'SonicWall'
    location:location
    gatewayIPAddress:'185.158.22.22'
    addressPrefixes:[
      '192.168.1.0/24'
    ]
  }
  dependsOn:[
    vng
  ]
}
module con 'Modules/vpnconnection-generic.bicep' = {
  name:'${rg1Name}connection'
 scope:(resourceGroup(rg1Name))
  params:{
    connectionName:'hq_to_azure'
    location:location
    connectionType:'IPsec'
    enableBgp:false
   localNetworkGatewayId:lgw.outputs.lngid
    sharedKey:'testkeys'
    virtualNetworkGatewayId:vng.outputs.vngid
  }
  dependsOn:[
   lgw
  ]
}

module vm 'Modules/vm-generic.bicep' = [for name in vmNames:  {
  name:'vm-${name}'
  scope:(resourceGroup(rg1Name))
  params:{
    rgName:rg1Name
    location:location
    SubnetName:vnet.outputs.subnetName
    namePrefix:namePrefix
    vmName:'${name}'
    adminUsername:'azureadmin'
    adminPassword:adminPassword
    availabilitySetPlatformFaultDomainCount:2
    availabilitySetPlatformUpdateDomainCount:5
  }
dependsOn:[
  vnet
]
  }]
