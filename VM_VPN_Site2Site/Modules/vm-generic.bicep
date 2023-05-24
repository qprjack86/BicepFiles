param rgName string
param VirtualNetworkName string = '${namePrefix}-vnet' 
param namePrefix string
param SubnetName string

param adminUsername string

@minLength(12)
@secure()
param adminPassword string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

param publicIpName string = '${vmName}-pip'

@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Dynamic'

@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Basic'

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
@allowed([
  '2008-R2-SP1'
  '2012-Datacenter'
  '2012-R2-Datacenter'
  '2016-Nano-Server'
  '2016-Datacenter-with-Containers'
  '2016-Datacenter'
  '2019-Datacenter'
  '2019-Datacenter-Core'
  '2019-Datacenter-Core-smalldisk'
  '2019-Datacenter-Core-with-Containers'
  '2019-Datacenter-Core-with-Containers-smalldisk'
  '2019-Datacenter-smalldisk'
  '2019-Datacenter-with-Containers'
  '2019-Datacenter-with-Containers-smalldisk'
  '2022-Datacenter'
  '2022-Datacenter-azure-edition'
])
param OSVersion string = '2019-Datacenter'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_D2_v3'

@description('Location for all resources.')
param location string

@description('Name of the virtual machine.')
param vmName string 

var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName = '${vmName}-Nic'
var networkSecurityGroupName = '${vmName}-NSG'

param availabilitySetName string = '${vmName}-Avset'
param availabilitySetPlatformFaultDomainCount int
param availabilitySetPlatformUpdateDomainCount int

resource stg 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

resource pip 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource securityGroup 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}


resource nic 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id:resourceId(rgName, 'Microsoft.Network/virtualNetworks/subnets', VirtualNetworkName, SubnetName)
          }
        
        }
      }
    ]
  networkSecurityGroup:{
    id:securityGroup.id
  }
  }
}

resource avail 'Microsoft.Compute/availabilitySets@2023-03-01' = {
  location:location
  name:availabilitySetName
  sku:{
    name: 'Aligned'
  }
  properties:{
    platformFaultDomainCount:availabilitySetPlatformFaultDomainCount
    platformUpdateDomainCount:availabilitySetPlatformUpdateDomainCount
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    availabilitySet:{
    id:avail.id
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        }
    }
  }
}

output hostname string = pip.properties.dnsSettings.fqdn
