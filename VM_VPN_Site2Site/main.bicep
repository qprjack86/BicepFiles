param rg1Name string 
param location string = resourceGroup().id
param addressSpace string
param namePrefix string 
param vmNames array = [
  'srv-dc-az'
  'srv-app-az'
]
//Password for VM's
@minLength(12)
@secure()
param adminPassword string

module vnet 'Modules/vnet-generic.bicep' ={
  name: '${rg1Name}-vnet'
  params: {
    namePrefix: namePrefix
    location: location
    addressSpace: addressSpace
  }
}

module vng 'Modules/virtualnet-gw.bicep' = {
  name:'${rg1Name}-vngw'
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
