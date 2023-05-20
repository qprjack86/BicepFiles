//Parameters
param location string 
param namePrefix string
param storageAccountName string = '${namePrefix}storageacc'
param shareNames array = []
  

//Create Storage Account
resource stg 'Microsoft.Storage/storageAccounts@2022-09-01'= {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties:{
    allowBlobPublicAccess:false
    supportsHttpsTrafficOnly:true
    minimumTlsVersion:'TLS1_2'
    networkAcls:{
      defaultAction: 'Deny'
      
    }
    encryption:{
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption:true
      services:{
        file:{
          enabled:true
          keyType:'Account'
        }
      }
    }
  }
}

//Create Azure Files
resource fileservices 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
  name: 'default'
  properties:{
    shareDeleteRetentionPolicy:{
      enabled:true
      days:7
    }
  }
  parent:stg
}
//Create the Fileshares
resource shares 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = [for share in shareNames: {
  name: share
  properties:{
    accessTier:'TransactionOptimized'
    enabledProtocols:'SMB'
  }
  parent:fileservices
}]

//Outputs  
output storageid string = stg.id
  