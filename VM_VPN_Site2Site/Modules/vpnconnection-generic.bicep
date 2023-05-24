param connectionName string
param location string
param connectionType string
param virtualNetworkGatewayId string
param enableBgp bool
param sharedKey string
param localNetworkGatewayId string

resource connectionName_resource 'Microsoft.Network/connections@2022-11-01' = {
  name:connectionName
  location:location
  properties:{
    connectionType:connectionType
    virtualNetworkGateway1:{
      id: virtualNetworkGatewayId
      properties:{

      }
    }
  enableBgp:enableBgp
  sharedKey:sharedKey
  localNetworkGateway2:{
    id:localNetworkGatewayId
    properties:{

    }
  }
  }
  dependsOn:[]
}
