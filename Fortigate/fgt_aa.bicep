@description('Username for the FortiGate VM')
param adminUsername string

@description('Password for the FortiGate VM')
@secure()
param adminPassword string

@description('Naming prefix for all deployed resources. The FortiGate VMs will have the suffix \'-FGT-A\' and \'-FGT-B\'. For example if the prefix is \'ACME-01\' the FortiGates will be named \'ACME-01-FGT-A\' and \'ACME-01-FGT-B\'')
param fortiGateNamePrefix string

@description('Identifies whether to to use PAYG (on demand licensing) or BYOL license model (where license is purchased separately)')
@allowed([
  'fortinet_fg-vm'
  'fortinet_fg-vm_payg_2022'
])
param fortiGateImageSKU string = 'fortinet_fg-vm'

@description('Select the image version')
@allowed([
  '6.4.13'
  '7.0.12'
  '7.2.5'
  '7.4.0'
  'latest'
])
param fortiGateImageVersion string = '7.2.5'

@description('The ARM template provides a basic configuration. Additional configuration can be added here.')
param fortiGateAdditionalCustomData string = ''

@description('Virtual Machine size selection')
@allowed([
  'Standard_F2s'
  'Standard_F4s'
  'Standard_F8s'
  'Standard_F16s'
  'Standard_F2'
  'Standard_F4'
  'Standard_F8'
  'Standard_F16'
  'Standard_F2s_v2'
  'Standard_F4s_v2'
  'Standard_F8s_v2'
  'Standard_F16s_v2'
  'Standard_F32s_v2'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
  'Standard_DS3_v2'
  'Standard_DS4_v2'
  'Standard_DS5_v2'
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'Standard_D16s_v3'
  'Standard_D32s_v3'
  'Standard_D2_v4'
  'Standard_D4_v4'
  'Standard_D8_v4'
  'Standard_D16_v4'
  'Standard_D32_v4'
  'Standard_D2s_v4'
  'Standard_D4s_v4'
  'Standard_D8s_v4'
  'Standard_D16s_v4'
  'Standard_D32s_v4'
  'Standard_D2a_v4'
  'Standard_D4a_v4'
  'Standard_D8a_v4'
  'Standard_D16a_v4'
  'Standard_D32a_v4'
  'Standard_D2as_v4'
  'Standard_D4as_v4'
  'Standard_D8as_v4'
  'Standard_D16as_v4'
  'Standard_D32as_v4'
  'Standard_D2_v5'
  'Standard_D4_v5'
  'Standard_D8_v5'
  'Standard_D16_v5'
  'Standard_D32_v5'
  'Standard_D2s_v5'
  'Standard_D4s_v5'
  'Standard_D8s_v5'
  'Standard_D16s_v5'
  'Standard_D32s_v5'
  'Standard_D2as_v5'
  'Standard_D4as_v5'
  'Standard_D8as_v5'
  'Standard_D16as_v5'
  'Standard_D32as_v5'
  'Standard_D2ads_v5'
  'Standard_D4ads_v5'
  'Standard_D8ads_v5'
  'Standard_D16ads_v5'
  'Standard_D32ads_v5'
  'Standard_D2ps_v5'
  'Standard_D4ps_v5'
  'Standard_D8ps_v5'
  'Standard_D16ps_v5'
  'Standard_D32ps_v5'
  'Standard_D2pds_v5'
  'Standard_D4pds_v5'
  'Standard_D8pds_v5'
  'Standard_D16pds_v5'
  'Standard_D32pds_v5'
  'Standard_D2pls_v5'
  'Standard_D4pls_v5'
  'Standard_D8pls_v5'
  'Standard_D16pls_v5'
  'Standard_D32pls_v5'
  'Standard_D2plds_v5'
  'Standard_D4plds_v5'
  'Standard_D8plds_v5'
  'Standard_D16plds_v5'
  'Standard_D32plds_v5'
  'Standard_E2ps_v5'
  'Standard_E4ps_v5'
  'Standard_E8ps_v5'
  'Standard_E16ps_v5'
  'Standard_E32ps_v5'
  'Standard_E2pds_v5'
  'Standard_E4pds_v5'
  'Standard_E8pds_v5'
  'Standard_E16pds_v5'
  'Standard_E32pds_v5'
])
param instanceType string = 'Standard_F2s'

@description('Deploy FortiGate VMs in an Availability Set or Availability Zones. If Availability Zones deployment is selected but the location does not support Availability Zones an Availability Set will be deployed. If Availability Zones deployment is selected and Availability Zones are available in the location, FortiGate A will be placed in Zone 1, FortiGate B will be placed in Zone 2')
@allowed([
  'Availability Set'
  'Availability Zones'
])
param availabilityOptions string = 'Availability Zones'

@description('Accelerated Networking enables direct connection between the VM and network card. Only available on 2 CPU F/Fs and 4 CPU D/Dsv2, D/Dsv3, E/Esv3, Fsv2, Lsv2, Ms/Mms and Ms/Mmsv2')
@allowed([
  'false'
  'true'
])
param acceleratedNetworking string = 'true'

@description('Public IP for the Load Balancer for inbound and outbound data of the FortiGate VMs')
@allowed([
  'new'
  'existing'
])
param publicIP1NewOrExisting string = 'new'

@description('Name of Public IP address, if no name is provided the default name will be the Resource Group Name as the Prefix and \'-FGT-PIP\' as the suffix')
param publicIP1Name string = ''

@description('Public IP Resource Group, this value is required if an existing Public IP is selected')
param publicIP1ResourceGroup string = ''

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
param vnetAddressPrefix string = '172.16.136.0/22'

@description('Subnet 1 Name')
param subnet1Name string = 'ExternalSubnet'

@description('Subnet 1 Prefix')
param subnet1Prefix string = '172.16.136.0/26'

@description('Subnet 1 start address, 2 consecutive private IPs are required')
param subnet1StartAddress string = '172.16.136.4'

@description('Subnet 2 Name')
param subnet2Name string = 'InternalSubnet'

@description('Subnet 2 Prefix')
param subnet2Prefix string = '172.16.136.64/26'

@description('Subnet 2 start address, 2 consecutive private IPs are required')
param subnet2StartAddress string = '172.16.136.68'

@description('Subnet 3 Name')
param subnet3Name string = 'ProtectedASubnet'

@description('Subnet 3 Prefix')
param subnet3Prefix string = '172.16.137.0/24'

@description('Enable Serial Console')
@allowed([
  'yes'
  'no'
])
param serialConsole string = 'yes'

@description('Connect to FortiManager')
@allowed([
  'yes'
  'no'
])
param fortiManager string = 'no'

@description('FortiManager IP or DNS name to connect to on port TCP/541')
param fortiManagerIP string = ''

@description('FortiManager serial number to add the deployed FortiGate into the FortiManager')
param fortiManagerSerial string = ''

@description('Primary FortiGate BYOL license content')
param fortiGateLicenseBYOLA string = ''

@description('Secondary FortiGate BYOL license content')
param fortiGateLicenseBYOLB string = ''

@description('Primary FortiGate BYOL FortiFlex license token')
param fortiGateLicenseFortiFlexA string = ''

@description('Secondary FortiGate BYOL FortiFlex license token')
param fortiGateLicenseFortiFlexB string = ''

@description('By default, the deployment will use Azure Marketplace images. In specific cases, using BYOL custom FortiGate images can be deployed. This requires a reference ')
param customImageReference string = ''

@description('Location for all resources.')
param location string = resourceGroup().location
param fortinetTags object = {
  publisher: 'Fortinet'
  template: 'Active-Active-ELB-ILB'
  provider: '6EB3B02F-50E5-4A3E-8CB8-2E12925831AA'
}

var imagePublisher = 'fortinet'
var imageOffer = 'fortinet_fortigate-vm_v5'
var availabilitySetName = '${fortiGateNamePrefix}-AvailabilitySet'
var availabilitySetId = {
  id: availabilitySet.id
}
var vnetNamevar = ((vnetName == '') ? '${fortiGateNamePrefix}-VNET' : vnetName)
var subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name))
var subnet2Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name))
var fgaVmName = '${fortiGateNamePrefix}-FGT-A'
var fgbVmName = '${fortiGateNamePrefix}-FGT-B'
var fmgCustomData = ((fortiManager == 'yes') ? '\nconfig system central-management\nset type fortimanager\n set fmg ${fortiManagerIP}\nset serial-number ${fortiManagerSerial}\nend\n config system interface\n edit port1\n append allowaccess fgfm\n end\n config system interface\n edit port2\n append allowaccess fgfm\n end\n' : '')
var customDataHeader = 'Content-Type: multipart/mixed; boundary="12345"\nMIME-Version: 1.0\n\n--12345\nContent-Type: text/plain; charset="us-ascii"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename="config"\n\n'
var fgaCustomDataBody = 'config system sdn-connector\nedit AzureSDN\nset type azure\nnext\nend\nconfig router static\n edit 1\n set gateway ${sn1GatewayIP}\n set device port1\n next\n edit 2\n set dst ${vnetAddressPrefix}\n set gateway ${sn2GatewayIP}\n set device port2\n next\n edit 3\nset dst 168.63.129.16 255.255.255.255\nset device port2\n set gateway ${sn2GatewayIP}\n next\nedit 4\nset dst 168.63.129.16 255.255.255.255\nset device port1\n set gateway ${sn1GatewayIP}\n next\n end\n config system probe-response\n set mode http-probe\n end\n config system interface\n edit port1\n set mode static\n set ip ${sn1IPfga}/${sn1CIDRmask}\n set description external\n set allowaccess ping ssh https probe-response\n next\n edit port2\n set mode static\n set ip ${sn2IPfga}/${sn2CIDRmask}\n set description internal\n set allowaccess ping ssh https probe-response\n next\n end\n${fmgCustomData}${fortiGateAdditionalCustomData}\n'
var fgbCustomDataBody = 'config system sdn-connector\nedit AzureSDN\nset type azure\nnext\nend\nconfig router static\n edit 1\n set gateway ${sn1GatewayIP}\n set device port1\n next\n edit 2\n set dst ${vnetAddressPrefix}\n set gateway ${sn2GatewayIP}\n set device port2\n next\n edit 3\nset dst 168.63.129.16 255.255.255.255\nset device port2\n set gateway ${sn2GatewayIP}\n next\nedit 4\nset dst 168.63.129.16 255.255.255.255\nset device port1\n set gateway ${sn1GatewayIP}\n next\n end\n config system probe-response\n set mode http-probe\n end\n config system interface\n edit port1\n set mode static\n set ip ${sn1IPfgb}/${sn1CIDRmask}\n set description external\n set allowaccess ping ssh https probe-response\n next\n edit port2\n set mode static\n set ip ${sn2IPfgb}/${sn2CIDRmask}\n set description internal\n set allowaccess ping ssh https probe-response\n next\n end\n${fmgCustomData}${fortiGateAdditionalCustomData}\n'
var customDataLicenseHeader = '--12345\nContent-Type: text/plain; charset="us-ascii"\nMIME-Version: 1.0\nContent-Transfer-Encoding: 7bit\nContent-Disposition: attachment; filename="license"\n\n'
var customDataFooter = '\n--12345--\n'
var fgaCustomDataFortiFlex = ((fortiGateLicenseFortiFlexA == '') ? '' : 'LICENSE-TOKEN:${fortiGateLicenseFortiFlexA}\n')
var fgbCustomDataFortiFlex = ((fortiGateLicenseFortiFlexB == '') ? '' : 'LICENSE-TOKEN:${fortiGateLicenseFortiFlexB}\n')
var fgaCustomDataCombined = '${customDataHeader}${fgaCustomDataBody}${customDataLicenseHeader}${fgaCustomDataFortiFlex}${fortiGateLicenseBYOLA}${customDataFooter}'
var fgbCustomDataCombined = '${customDataHeader}${fgbCustomDataBody}${customDataLicenseHeader}${fgbCustomDataFortiFlex}${fortiGateLicenseBYOLB}${customDataFooter}'
var fgaCustomData = base64((((fortiGateLicenseBYOLA == '') && (fortiGateLicenseFortiFlexA == '')) ? fgaCustomDataBody : fgaCustomDataCombined))
var fgbCustomData = base64((((fortiGateLicenseBYOLB == '') && (fortiGateLicenseFortiFlexB == '')) ? fgbCustomDataBody : fgbCustomDataCombined))
var routeTable3Name = '${fortiGateNamePrefix}-RouteTable-${subnet3Name}'
var routeTable3Id = routeTable3.id
var fgaNic1Name = '${fgaVmName}-Nic1'
var fgaNic1Id = fgaNic1.id
var fgaNic2Name = '${fgaVmName}-Nic2'
var fgaNic2Id = fgaNic2.id
var fgbNic1Name = '${fgbVmName}-Nic1'
var fgbNic1Id = fgbNic1.id
var fgbNic2Name = '${fgbVmName}-Nic2'
var fgbNic2Id = fgbNic2.id
var serialConsoleEnabled = ((serialConsole == 'yes') ? true : false)
var acceleratedNetworkingEnabled = ((acceleratedNetworking =='yes') ? true : false)
var publicIP1Namevar = ((publicIP1Name == '') ? '${fortiGateNamePrefix}-FGT-PIP' : publicIP1Name)
var publicIP1Id = ((publicIP1NewOrExisting == 'new') ? publicIP1.id : resourceId(publicIP1ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP1Namevar))
var nsgName = '${fortiGateNamePrefix}-NSG-Allow-All'
var nsgId = nsg.id
var sn1IPArray = split(subnet1Prefix, '.')
var sn1IPArray2ndString = string(sn1IPArray[3])
var sn1IPArray2nd = split(sn1IPArray2ndString, '/')
var sn1CIDRmask = string(int(sn1IPArray2nd[1]))
var sn1IPArray3 = string((int(sn1IPArray2nd[0]) + 1))
var sn1IPArray2 = string(int(sn1IPArray[2]))
var sn1IPArray1 = string(int(sn1IPArray[1]))
var sn1IPArray0 = string(int(sn1IPArray[0]))
var sn1GatewayIP = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${sn1IPArray3}'
var sn1IPStartAddress = split(subnet1StartAddress, '.')
var sn1IPfga = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${int(sn1IPStartAddress[3])}'
var sn1IPfgb = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${(int(sn1IPStartAddress[3]) + 1)}'
var sn2IPArray = split(subnet2Prefix, '.')
var sn2IPArray2ndString = string(sn2IPArray[3])
var sn2IPArray2nd = split(sn2IPArray2ndString, '/')
var sn2CIDRmask = string(int(sn2IPArray2nd[1]))
var sn2IPArray3 = string((int(sn2IPArray2nd[0]) + 1))
var sn2IPArray2 = string(int(sn2IPArray[2]))
var sn2IPArray1 = string(int(sn2IPArray[1]))
var sn2IPArray0 = string(int(sn2IPArray[0]))
var sn2GatewayIP = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${sn2IPArray3}'
var sn2IPStartAddress = split(subnet2StartAddress, '.')
var sn2IPlb = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${int(sn2IPStartAddress[3])}'
var sn2IPfga = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPStartAddress[3]) + 1)}'
var sn2IPfgb = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPStartAddress[3]) + 2)}'
var internalLBName = '${fortiGateNamePrefix}-InternalLoadBalancer'
var internalLBFEName = '${fortiGateNamePrefix}-ILB-${subnet2Name}-FrontEnd'
var internalLBFEId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', internalLBName, internalLBFEName)
var internalLBBEName = '${fortiGateNamePrefix}-ILB-${subnet2Name}-BackEnd'
var internalLBBEId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', internalLBName, internalLBBEName)
var internalLBProbeName = 'lbprobe'
var internalLBProbeId = resourceId('Microsoft.Network/loadBalancers/probes', internalLBName, internalLBProbeName)
var externalLBName_NatRule_FGAdminPerm_fga = '${fgaVmName}FGAdminPerm'
var externalLBId_NatRule_FGAdminPerm_fga = resourceId('Microsoft.Network/loadBalancers/inboundNatRules', externalLBName, externalLBName_NatRule_FGAdminPerm_fga)
var externalLBName_NatRule_SSH_fga = '${fgaVmName}SSH'
var externalLBId_NatRule_SSH_fga = resourceId('Microsoft.Network/loadBalancers/inboundNatRules', externalLBName, externalLBName_NatRule_SSH_fga)
var externalLBName_NatRule_FGAdminPerm_fgb = '${fgbVmName}FGAdminPerm'
var externalLBId_NatRule_FGAdminPerm_fgb = resourceId('Microsoft.Network/loadBalancers/inboundNatRules', externalLBName, externalLBName_NatRule_FGAdminPerm_fgb)
var externalLBName_NatRule_SSH_fgb = '${fgbVmName}SSH'
var externalLBId_NatRule_SSH_fgb = resourceId('Microsoft.Network/loadBalancers/inboundNatRules', externalLBName, externalLBName_NatRule_SSH_fgb)
var externalLBName = '${fortiGateNamePrefix}-ExternalLoadBalancer'
var externalLBFEName = '${fortiGateNamePrefix}-ELB-${subnet1Name}-FrontEnd'
var externalLBFEId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', externalLBName, externalLBFEName)
var externalLBBEName = '${fortiGateNamePrefix}-ELB-${subnet1Name}-BackEnd'
var externalLBBEId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', externalLBName, externalLBBEName)
var externalLBProbeName = 'lbprobe'
var externalLBProbeId = resourceId('Microsoft.Network/loadBalancers/probes', externalLBName, externalLBProbeName)
var useAZ = ((!empty(pickZones('Microsoft.Compute', 'virtualMachines', location))) && (availabilityOptions == 'Availability Zones'))
var pipZones = (useAZ ? pickZones('Microsoft.Network', 'publicIPAddresses', location, 3) : null)
var zone1 = [
  '1'
]
var zone2 = [
  '2'
]
var zones = [
  '1'
  '2'
  '3'
]
var imageReferenceMarketplace = {
  publisher: imagePublisher
  offer: imageOffer
  sku: fortiGateImageSKU
  version: fortiGateImageVersion
}
var imageReferenceCustomImage = {
  id: customImageReference
}
var virtualMachinePlan = {
  name: fortiGateImageSKU
  publisher: imagePublisher
  product: imageOffer
}

module fortiGateNamePrefix_fortinetdeployment_id './nested_fortiGateNamePrefix_fortinetdeployment_id.bicep' = {
  name: '${fortiGateNamePrefix}-fortinetdeployment-${uniqueString(resourceGroup().id)}'
  params: {}
}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2022-08-01' = if (!useAZ) {
  name: availabilitySetName
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 2
  }
  sku: {
    name: 'Aligned'
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = if (vnetNewOrExisting == 'new') {
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
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
          routeTable: {
            id: routeTable3Id
          }
        }
      }
    ]
  }
}

resource routeTable3 'Microsoft.Network/routeTables@2022-05-01' = {
  name: routeTable3Name
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  properties: {
    routes: [
      {
        name: 'toDefault'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: nsgName
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  properties: {
    securityRules: [
      {
        name: 'AllowAllInbound'
        properties: {
          description: 'Allow all in'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowAllOutbound'
        properties: {
          description: 'Allow all out'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 105
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource publicIP1 'Microsoft.Network/publicIPAddresses@2022-05-01' = if (publicIP1NewOrExisting == 'new') {
  name: publicIP1Namevar
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  sku: {
    name: 'Standard'
  }
  zones: pipZones
  properties: {
    publicIPAllocationMethod: 'static'
    dnsSettings: {
      domainNameLabel: '${toLower(fortiGateNamePrefix)}-${uniqueString(resourceGroup().id)}'
    }
  }
}

resource externalLB 'Microsoft.Network/loadBalancers@2022-05-01' = {
  name: externalLBName
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: externalLBFEName
        properties: {
          publicIPAddress: {
            id: publicIP1Id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: externalLBBEName
      }
    ]
    loadBalancingRules: [
      {
        properties: {
          frontendIPConfiguration: {
            id: externalLBFEId
          }
          backendAddressPool: {
            id: externalLBBEId
          }
          probe: {
            id: externalLBProbeId
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: true
          idleTimeoutInMinutes: 5
        }
        name: 'ExternalLBRule-FE-http'
      }
      {
        properties: {
          frontendIPConfiguration: {
            id: externalLBFEId
          }
          backendAddressPool: {
            id: externalLBBEId
          }
          probe: {
            id: externalLBProbeId
          }
          protocol: 'Udp'
          frontendPort: 10551
          backendPort: 10551
          enableFloatingIP: true
          idleTimeoutInMinutes: 5
        }
        name: 'ExternalLBRule-FE-udp10551'
      }
    ]
    inboundNatRules: [
      {
        name: externalLBName_NatRule_SSH_fga
        properties: {
          frontendIPConfiguration: {
            id: externalLBFEId
          }
          protocol: 'Tcp'
          frontendPort: 50030
          backendPort: 22
          enableFloatingIP: false
        }
      }
      {
        name: externalLBName_NatRule_FGAdminPerm_fga
        properties: {
          frontendIPConfiguration: {
            id: externalLBFEId
          }
          protocol: 'Tcp'
          frontendPort: 40030
          backendPort: 443
          enableFloatingIP: false
        }
      }
      {
        name: externalLBName_NatRule_SSH_fgb
        properties: {
          frontendIPConfiguration: {
            id: externalLBFEId
          }
          protocol: 'Tcp'
          frontendPort: 50031
          backendPort: 22
          enableFloatingIP: false
        }
      }
      {
        name: externalLBName_NatRule_FGAdminPerm_fgb
        properties: {
          frontendIPConfiguration: {
            id: externalLBFEId
          }
          protocol: 'Tcp'
          frontendPort: 40031
          backendPort: 443
          enableFloatingIP: false
        }
      }
    ]
    probes: [
      {
        properties: {
          protocol: 'Tcp'
          port: 8008
          intervalInSeconds: 5
          numberOfProbes: 2
        }
        name: 'lbprobe'
      }
    ]
  }
}

resource internalLB 'Microsoft.Network/loadBalancers@2022-05-01' = {
  name: internalLBName
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: internalLBFEName
        properties: {
          privateIPAddress: sn2IPlb
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnet2Id
          }
        }
        zones: (useAZ ? zones : null)
      }
    ]
    backendAddressPools: [
      {
        name: internalLBBEName
      }
    ]
    loadBalancingRules: [
      {
        properties: {
          frontendIPConfiguration: {
            id: internalLBFEId
          }
          backendAddressPool: {
            id: internalLBBEId
          }
          probe: {
            id: internalLBProbeId
          }
          protocol: 'all'
          frontendPort: 0
          backendPort: 0
          enableFloatingIP: true
          idleTimeoutInMinutes: 5
        }
        name: 'lbruleFEall'
      }
    ]
    probes: [
      {
        properties: {
          protocol: 'Tcp'
          port: 8008
          intervalInSeconds: 5
          numberOfProbes: 2
        }
        name: 'lbprobe'
      }
    ]
  }
  dependsOn: [
    vnet
  ]
}

resource fgaNic1 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: fgaNic1Name
  location: location
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: sn1IPfga
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnet1Id
          }
          loadBalancerBackendAddressPools: [
            {
              id: externalLBBEId
            }
          ]
          loadBalancerInboundNatRules: [
            {
              id: externalLBId_NatRule_SSH_fga
            }
            {
              id: externalLBId_NatRule_FGAdminPerm_fga
            }
          ]
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworkingEnabled
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    vnet
  ]
}

resource fgbNic1 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: fgbNic1Name
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: sn1IPfgb
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnet1Id
          }
          loadBalancerBackendAddressPools: [
            {
              id: externalLBBEId
            }
          ]
          loadBalancerInboundNatRules: [
            {
              id: externalLBId_NatRule_SSH_fgb
            }
            {
              id: externalLBId_NatRule_FGAdminPerm_fgb
            }
          ]
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworkingEnabled
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    vnet
  ]
}

resource fgaNic2 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: fgaNic2Name
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: sn2IPfga
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnet2Id
          }
          loadBalancerBackendAddressPools: [
            {
              id: internalLBBEId
            }
          ]
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworkingEnabled
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    vnet
    
  ]
}

resource fgbNic2 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: fgbNic2Name
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: sn2IPfgb
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnet2Id
          }
          loadBalancerBackendAddressPools: [
            {
              id: internalLBBEId
            }
          ]
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworkingEnabled
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    vnet   
  ]
}

resource fgaVm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: fgaVmName
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  zones: (useAZ ? zone1 : null)
  plan: (((fortiGateImageSKU == 'fortinet_fg-vm') && (customImageReference != '')) ? null : virtualMachinePlan)
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    availabilitySet: ((!useAZ) ? availabilitySetId : null)
    osProfile: {
      computerName: fgaVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: fgaCustomData
    }
    storageProfile: {
      imageReference: (((fortiGateImageSKU == 'fortinet_fg-vm') && (customImageReference != '')) ? imageReferenceCustomImage : imageReferenceMarketplace)
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          diskSizeGB: 30
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: fgaNic1Id
        }
        {
          properties: {
            primary: false
          }
          id: fgaNic2Id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: serialConsoleEnabled
      }
    }
  }
 
}

resource fgbVm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: fgbVmName
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  zones: (useAZ ? zone2 : null)
  plan: (((fortiGateImageSKU == 'fortinet_fg-vm') && (customImageReference != '')) ? null : virtualMachinePlan)
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    availabilitySet: ((!useAZ) ? availabilitySetId : null)
    osProfile: {
      computerName: fgbVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: fgbCustomData
    }
    storageProfile: {
      imageReference: (((fortiGateImageSKU == 'fortinet_fg-vm') && (customImageReference != '')) ? imageReferenceCustomImage : imageReferenceMarketplace)
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: [
        {
          diskSizeGB: 30
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: fgbNic1Id
        }
        {
          properties: {
            primary: false
          }
          id: fgbNic2Id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: serialConsoleEnabled
      }
    }
  }
}

output fortiGatePublicIP string = ((publicIP1NewOrExisting == 'new') ? reference(publicIP1Id).ipAddress : '')
output fortiGateFQDN string = ((publicIP1NewOrExisting == 'new') ? reference(publicIP1Id).dnsSettings.fqdn : '')
