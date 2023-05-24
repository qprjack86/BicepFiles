param localNetworkGatewayName string
param location string 
param gatewayIPAddress string
param addressPrefixes array = []

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' ={
  name:localNetworkGatewayName
  location:location
  properties:{
    localNetworkAddressSpace:{
      addressPrefixes: addressPrefixes
    }
    gatewayIpAddress:gatewayIPAddress
  }
}
output lngid string = localNetworkGateway.id
