targetScope = 'subscription'
param location string = deployment().location
param rgname string = 'Fileshare_RG'
param namePrefix string = 'cwl'
param shareNames array = [
  'company'
  'users'
]

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgname
  location: location
}

module stg 'Modules/fileshare-generic.bicep'= {
  scope:(resourceGroup(rgname)) 
  name: 'storaccount'
  params: {
        namePrefix:namePrefix
        shareNames:shareNames
        location:location
  }
}

module vnet 'Modules/vnet-generic.bicep'= {
  scope:(resourceGroup(rgname))
  name:'vnet'
  params:{
        namePrefix: namePrefix
        location:location
  }
}

module pl 'Modules/pl-dns-generic.bicep' = {
  scope: (resourceGroup(rgname))
  name: 'PL_DNS'
  params: {
    location:location
    storageID:stg.outputs.storageid
    namePrefix: namePrefix
    subnetID: vnet.outputs.subnetId
    vnetName:vnet.outputs.vnetName

    
  }
}
