@description('Username for the Virtual Machine')
param adminUsername string

@description('Password for the Virtual Machine')
@secure()
param adminPassword string

@description('Name for FortiGate virtual appliances (A & B will be appended to the end of each respectively)')
param fortiGateNamePrefix string

@description('Identifies whether to to use PAYG (on demand licensing) or BYOL license model (where license is purchased separately)')
@allowed([
  'fortinet_fg-vm'
  'fortinet_fg-vm_payg_20190624'
])
param fortiGateImageSKU string = 'fortinet_fg-vm'

@description('Only 6.x has the A/P HA feature currently')
@allowed([
  '6.2.0'
  '6.2.2'
  '6.2.4'
  '6.2.5'
  '6.4.0'
  '6.4.2'
  '6.4.3'
  '6.4.5'
  '6.4.6'
  '6.4.7'
  '6.4.8'
  '7.0.0'
  '7.0.1'
  '7.0.2'
  '7.0.3'
  '7.0.4'
  '7.0.5'
  'latest'
])
param fortiGateImageVersion string = 'latest'

@description('Virtual Machine size selection - must be F4 or other instance that supports 4 NICs')
@allowed([
  'Standard_F4'
  'Standard_F4s'
  'Standard_F8'
  'Standard_F8s'
  'Standard_F8s_v2'
  'Standard_F16'
  'Standard_F16s'
  'Standard_F16s_v2'
])
param instanceType string = 'Standard_F4s'

@description('Accelerated Networking enables direct connection between the VM and network card. Only available on 2 CPU D/DSv2 and F/Fs and 4 CPU D/Dsv3, E/Esv3, Fsv2, Lsv2, Ms/Mms and Ms/Mmsv2')
param acceleratedNetworking bool = true

@description('Choose between an existing or new public IP for the External Azure Load Balancer')
@allowed([
  'new'
  'existing'
])
param publicIPNewOrExisting string = 'new'

@description('Choose between an existing or new public IP for the Active Fortigate')
@allowed([
  'new'
  'existing'
])
param publicIP2NewOrExisting string = 'new'

@description('Choose between an existing or new public IP for the Passive Fortigate')
@allowed([
  'new'
  'existing'
])
param publicIP3NewOrExisting string = 'new'

@description('Name of Public IP address element')
param publicIPName string = 'FGTAPClusterPublicIP'

@description('Resource group to which the Public IP belongs')
param publicIPResourceGroup string = ''

@description('Name of Public IP address element')
param publicIP2Name string = 'FGTAMgmtPublicIP'

@description('Resource group to which the Public IP belongs')
param publicIP2ResourceGroup string = ''

@description('Name of Public IP address element')
param publicIP3Name string = 'FGTBMgmtPublicIP'

@description('Resource group to which the Public IP belongs')
param publicIP3ResourceGroup string = ''

@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExisting string = 'new'

@description('Name of the Azure virtual network')
param vnetName string = ''

@description('Resource Group containing the existing virtual network (with new vnet the current resourcegroup is used)')
param vnetResourceGroup string = ''

@description('Virtual Network Address prefix')
param vnetAddressPrefix string = '172.16.136.0/22'

@description('External Subnet')
param subnet1Name string = 'ExternalSubnet'

@description('External Subnet Prefix')
param subnet1Prefix string = '172.16.136.0/26'

@description('Internal Subnet')
param subnet2Name string = 'InternalSubnet'

@description('Internal Subnet Prefix')
param subnet2Prefix string = '172.16.136.64/26'

@description('HA Sync Subnet 3 Name')
param subnet3Name string = 'HASyncSubnet'

@description('HA Sync Subnet 3 Prefix')
param subnet3Prefix string = '172.16.136.128/26'

@description('Management Subnet 4 Name')
param subnet4Name string = 'ManagementSubnet'

@description('Management Subnet 4 Prefix')
param subnet4Prefix string = '172.16.136.192/26'

@description('Protected A Subnet 5 Name')
param subnet5Name string = 'ProtectedASubnet'

@description('Protected A Subnet 5 Prefix')
param subnet5Prefix string = '172.16.137.0/24'

@description('Protected B Subnet 6 Name')
param subnet6Name string = 'ProtectedBSubnet'

@description('Protected B Subnet 6 Prefix')
param subnet6Prefix string = '172.16.138.0/24'

@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExistingSpoke1 string = 'new'

@description('Name of the Azure virtual network for Spoke1')
param vnetNameSpoke1 string = ''

@description('Resource Group containing the existing virtual network Spoke 1 (with new vnet the current resourcegroup is used)')
param vnetResourceGroupSpoke1 string = ''

@description('Subnet 1 Spoke 1')
param subnet1Spoke1Name string = 'SPOKE1Subnet'

@description('Subnet 1 Spoke 1')
param subnet1Spoke1Prefix string = '172.16.140.0/26'

@description('Virtual Network Address prefix for Spoke 1')
param vnetAddressPrefixSpoke1 string = '172.16.140.0/24'

@description('Identify whether to use a new or existing vnet')
@allowed([
  'new'
  'existing'
])
param vnetNewOrExistingSpoke2 string = 'new'

@description('Name of the Azure virtual network for Spoke1')
param vnetNameSpoke2 string = ''

@description('Resource Group containing the existing virtual network Spoke 1 (with new vnet the current resourcegroup is used)')
param vnetResourceGroupSpoke2 string = ''

@description('Virtual Network Address prefix for Spoke 2')
param vnetAddressPrefixSpoke2 string = '172.16.142.0/24'

@description('Subnet 1 Spoke 2')
param subnet1Spoke2Name string = 'SPOKE2Subnet'

@description('Subnet 1 Spoke 2')
param subnet1Spoke2Prefix string = '172.16.142.0/26'

@description('Location for all resources.')
param location string = resourceGroup().location
param fortinetTags object = {
  publisher: 'Fortinet'
  template: 'VNET Peering'
  provider: '6EB3B02F-50E5-4A3E-8CB8-2E12925831AB-VNETPeering'
}

var imagePublisher = 'fortinet'
var imageOffer = 'fortinet_fortigate-vm_v5'
var compute_AvailabilitySet_FG_Name = '${fortiGateNamePrefix}-AvailabilitySet'
var compute_AvailabilitySet_FG_Id = compute_AvailabilitySet_FG.id
var vnetNamevar = ((vnetName == '') ? '${fortiGateNamePrefix}-VNET' : vnetName)
var vnetId = ((vnetNewOrExisting == 'new') ? vnet.id : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks', vnetNamevar))
var subnet1Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet1Name))
var subnet2Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet2Name))
var subnet3Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet3Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet3Name))
var subnet4Id = ((vnetNewOrExisting == 'new') ? resourceId('Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet4Name) : resourceId(vnetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNamevar, subnet4Name))
var vnetNameSpoke1var = ((vnetNameSpoke1 == '') ? '${fortiGateNamePrefix}-VNET-SPOKE1' : vnetNameSpoke1)
var vnetIdSpoke1 = ((vnetNewOrExistingSpoke1 == 'new') ? vnetNameSpoke1_resource.id : resourceId(vnetResourceGroupSpoke1, 'Microsoft.Network/virtualNetworks', vnetNameSpoke1var))
var vnetNameSpoke2var = ((vnetNameSpoke2 == '') ? '${fortiGateNamePrefix}-VNET-SPOKE2' : vnetNameSpoke2)
var vnetIdSpoke2 = ((vnetNewOrExistingSpoke2 == 'new') ? vnetNameSpoke2_resource.id : resourceId(vnetResourceGroupSpoke2, 'Microsoft.Network/virtualNetworks', vnetNameSpoke2var))
var fgaVmName = '${fortiGateNamePrefix}-FGT-A'
var fgbVmName = '${fortiGateNamePrefix}-FGT-B'
var fgaCustomData = base64('config system sdn-connector\nedit AzureSDN\nset type azure\nend\nend\nconfig router static\nedit 1\nset gateway ${sn1GatewayIP}\nset device port1\nnext\nedit 2\nset dst ${vnetAddressPrefix}\nset gateway ${sn2GatewayIP}\nset device port2\nnext\nedit 3\nset dst 168.63.129.16 255.255.255.255\nset device port2\nset gateway ${sn2GatewayIP}\nnext\nedit 4\nset dst 168.63.129.16 255.255.255.255\nset device port1\nset gateway ${sn1GatewayIP}\nnext\nedit 5\nset dst ${vnetAddressPrefixSpoke1}\nset gateway ${sn2GatewayIP}\nset device port2\nset comment Spoke1-Subnet\nnext\nedit 6\nset dst ${vnetAddressPrefixSpoke2}\nset gateway ${sn2GatewayIP}\nset device port2\nset comment Spoke2-Subnet\nnext\nend\nconfig system probe-response\nset http-probe-value OK\nset mode http-probe\nend\nconfig system interface\nedit port1\nset mode static\nset ip ${sn1IPfga}/${sn1CIDRmask}\nset description external\nset allowaccess probe-response\nnext\nedit port2\nset mode static\nset ip ${sn2IPfga}/${sn2CIDRmask}\nset description internal\nset allowaccess probe-response\nnext\nedit port3\nset mode static\nset ip ${sn3IPfga}/${sn3CIDRmask}\nset description hasyncport\nnext\nedit port4\nset mode static\nset ip ${sn4IPfga}/${sn4CIDRmask}\nset description management\nset allowaccess ping https ssh ftm\nnext\nend\nconfig firewall address\nedit Spoke1-subnet\nset associated-interface port2\nset subnet ${subnet1Spoke1Prefix}\nnext\nedit Spoke2-subnet\nset associated-interface port2\nset subnet ${subnet1Spoke2Prefix}\nnext\nedit ProtectedASubnet\nset associated-interface port2\nset subnet ${subnet5Prefix}\nnext\nedit ProtectedBSubnet\nset associated-interface port2\nset subnet ${subnet6Prefix}\nnext\nend\nconfig firewall policy\nedit 1\nset name Spoke1subnet-to-Spoke2subnet\nset srcintf port2\nset dstintf port2\nset srcaddr Spoke1-subnet\nset dstaddr Spoke2-subnet\nset action accept\nset schedule always\nset service ALL\nset fsso disable\nnext\nedit 2\nset name Spoke2subnet-to-Spoke1subnet\nset srcintf port2\nset dstintf port2\nset srcaddr Spoke2-subnet\nset dstaddr Spoke1-subnet\nset action accept\nset schedule always\nset service ALL\nset fsso disable\nnext\nedit 3\nset name SpokesSubnets-to-ProtectedSubnets\nset srcintf port2\nset dstintf port2\nset srcaddr Spoke1-subnet Spoke2-subnet\nset dstaddr ProtectedASubnet ProtectedBSubnet\nset action accept\nset schedule always\nset service ALL\nset fsso disable\nnext\nedit 4\nset name ProtectedSubnets-to-SpokeSubnets\nset srcintf port2\nset dstintf port2\nset srcaddr ProtectedASubnet ProtectedBSubnet\nset dstaddr Spoke1-subnet Spoke2-subnet\nset action accept\nset schedule always\nset service ALL\nset fsso disable\nnext\nedit 5\nset name Protected&SpokeSubnets-to-Internet\nset srcintf port2\nset dstintf port1\nset srcaddr ProtectedASubnet ProtectedBSubnet Spoke1-subnet Spoke2-subnet\nset dstaddr all\nset action accept\nset schedule always\nset service ALL\nset utm-status enable\nset fsso disable\nset av-profile default\nset webfilter-profile default\nset dnsfilter-profile default\nset ips-sensor default\nset application-list default\nset ssl-ssh-profile certificate-inspection\nset nat enable\nnext\nend\nconfig system ha\nset group-name AzureHA\nset mode a-p\nset hbdev port3 100\nset session-pickup enable\nset session-pickup-connectionless enable\nset ha-mgmt-status enable\nconfig ha-mgmt-interfaces\nedit 1\nset interface port4\nset gateway ${sn4GatewayIP}\nnext\nend\nset override disable\nset priority 255\nset unicast-hb enable\nset unicast-hb-peerip ${sn3IPfgb}\n end')
var fgbCustomData = base64('config system sdn-connector\nedit AzureSDN\nset type azure\nend\nend\nconfig router static\nedit 1\nset gateway ${sn1GatewayIP}\nset device port1\nnext\nedit 2\nset dst ${vnetAddressPrefix}\nset gateway ${sn2GatewayIP}\nset device port2\nnext\nedit 3\nset dst 168.63.129.16 255.255.255.255\nset device port2\nset gateway ${sn2GatewayIP}\nnext\nedit 4\nset dst 168.63.129.16 255.255.255.255\nset device port1\nset gateway ${sn1GatewayIP}\nnext\nedit 5\nset dst ${vnetAddressPrefixSpoke1}\nset gateway ${sn2GatewayIP}\nset device port2\nset comment Spoke1-Subnet\nnext\nedit 6\nset dst ${vnetAddressPrefixSpoke2}\nset gateway ${sn2GatewayIP}\nset device port2\nset comment Spoke2-Subnet\nnext\nend\nconfig system probe-response\nset http-probe-value OK\nset mode http-probe\nend\nconfig system interface\nedit port1\nset mode static\nset ip ${sn1IPfgb}/${sn1CIDRmask}\nset description external\nset allowaccess probe-response\nnext\nedit port2\nset mode static\nset ip ${sn2IPfgb}/${sn2CIDRmask}\nset description internal\nset allowaccess probe-response\nnext\nedit port3\nset mode static\nset ip ${sn3IPfgb}/${sn3CIDRmask}\nset description hasyncport\nnext\nedit port4\nset mode static\nset ip ${sn4IPfgb}/${sn4CIDRmask}\nset description management\nset allowaccess ping https ssh ftm\nnext\nend\nconfig firewall address\nedit Spoke1-subnet\nset associated-interface port2\nset subnet ${subnet1Spoke1Prefix}\nnext\nedit Spoke2-subnet\nset associated-interface port2\nset subnet ${subnet1Spoke2Prefix}\nnext\nedit ProtectedASubnet\nset associated-interface port2\nset subnet ${subnet5Prefix}\nnext\nedit ProtectedBSubnet\nset associated-interface port2\nset subnet ${subnet6Prefix}\nnext\nend\nconfig firewall policy\nedit 1\nset name Spoke1subnet-to-Spoke2subnet\nset srcintf port2\nset dstintf port2\nset srcaddr Spoke1-subnet\nset dstaddr Spoke2-subnet\nset action accept\nset schedule always\nset service ALL\nset fsso disable\nnext\nedit 2\nset name Spoke2subnet-to-Spoke1subnet\nset srcintf port2\nset dstintf port2\nset srcaddr Spoke2-subnet\nset dstaddr Spoke1-subnet\nset action accept\nset schedule always\nset service ALL\nset fsso disable\nnext\nedit 3\nset name SpokesSubnets-to-ProtectedSubnets\nset srcintf port2\nset dstintf port2\nset srcaddr Spoke1-subnet Spoke2-subnet\nset dstaddr ProtectedASubnet ProtectedBSubnet\nset action accept\nset schedule always\nset service ALL\nset fsso disable\nnext\nedit 4\nset name ProtectedSubnets-to-SpokeSubnets\nset srcintf port2\nset dstintf port2\nset srcaddr ProtectedASubnet ProtectedBSubnet\nset dstaddr Spoke1-subnet Spoke2-subnet\nset action accept\nset schedule always\nset service ALL\nset fsso disable\nnext\nedit 5\nset name Protected&SpokeSubnets-to-Internet\nset srcintf port2\nset dstintf port1\nset srcaddr ProtectedASubnet ProtectedBSubnet Spoke1-subnet Spoke2-subnet\nset dstaddr all\nset action accept\nset schedule always\nset service ALL\nset utm-status enable\nset fsso disable\nset av-profile default\nset webfilter-profile default\nset dnsfilter-profile default\nset ips-sensor default\nset application-list default\nset ssl-ssh-profile certificate-inspection\nset nat enable\nnext\nend\nconfig system ha\nset group-name AzureHA\nset mode a-p\nset hbdev port3 100\nset session-pickup enable\nset session-pickup-connectionless enable\nset ha-mgmt-status enable\nconfig ha-mgmt-interfaces\nedit 1\nset interface port4\nset gateway ${sn4GatewayIP}\nnext\nend\nset override disable\nset priority 1\nset unicast-hb enable\nset unicast-hb-peerip ${sn3IPfga}\n end')
var routeTableProtectedAName = '${fortiGateNamePrefix}-RT-PROTECTED-A'
var routeTableProtectedAId = routeTableProtectedA.id
var routeTableProtectedBName = '${fortiGateNamePrefix}-RT-PROTECTED-B'
var routeTableProtectedBId = routeTableProtectedB.id
var routeTableSpoke1Name = '${fortiGateNamePrefix}-RT-SPOKE-1'
var routeTableSpoke1Id = routeTableSpoke1.id
var routeTableSpoke2Name = '${fortiGateNamePrefix}-RT-SPOKE-2'
var routeTableSpoke2Id = routeTableSpoke2.id
var hubtoSpoke1PeeringName = '${vnetNamevar}To${vnetNameSpoke1var}'
var spoke1toHubPeeringName = '${vnetNameSpoke1var}To${vnetNamevar}'
var hubtoSpoke2PeeringName = '${vnetNamevar}To${vnetNameSpoke2var}'
var spoke2toHubPeeringName = '${vnetNameSpoke2var}To${vnetNamevar}'
var fgaNic1Name = '${fgaVmName}-Nic1'
var fgaNic1Id = fgaNic1.id
var fgaNic2Name = '${fgaVmName}-Nic2'
var fgaNic2Id = fgaNic2.id
var fgbNic1Name = '${fgbVmName}-Nic1'
var fgbNic1Id = fgbNic1.id
var fgbNic2Name = '${fgbVmName}-Nic2'
var fgbNic2Id = fgbNic2.id
var fgaNic3Name = '${fgaVmName}-Nic3'
var fgaNic3Id = fgaNic3.id
var fgbNic3Name = '${fgbVmName}-Nic3'
var fgbNic3Id = fgbNic3.id
var fgaNic4Name = '${fgaVmName}-Nic4'
var fgaNic4Id = fgaNic4.id
var fgbNic4Name = '${fgbVmName}-Nic4'
var fgbNic4Id = fgbNic4.id
var publicIPNamevar = ((publicIPName == '') ? '${fortiGateNamePrefix}-FGT-PIP' : publicIPName)
var publicIPId = ((publicIPNewOrExisting == 'new') ? publicIP.id : resourceId(publicIPResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIPNamevar))
var publicIP2Namevar = ((publicIP2Name == '') ? '${fortiGateNamePrefix}-FGT-A-MGMT-PIP' : publicIP2Name)
var publicIP2Id = ((publicIP2NewOrExisting == 'new') ? publicIP2.id : resourceId(publicIP2ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP2Namevar))
var publicIP3Namevar = ((publicIP3Name == '') ? '${fortiGateNamePrefix}-FGT-B-MGMT-PIP' : publicIP3Name)
var publicIP3Id = ((publicIP3NewOrExisting == 'new') ? publicIP3.id : resourceId(publicIP3ResourceGroup, 'Microsoft.Network/publicIPAddresses', publicIP3Namevar))
var NSGName = '${fortiGateNamePrefix}-${uniqueString(resourceGroup().id)}-NSG'
var NSGId = NSG.id
var sn1IPArray = split(subnet1Prefix, '.')
var sn1IPArray2ndString = string(sn1IPArray[3])
var sn1IPArray2nd = split(sn1IPArray2ndString, '/')
var sn1CIDRmask = string(int(sn1IPArray2nd[1]))
var sn1IPArray3 = string((int(sn1IPArray2nd[0]) + 1))
var sn1IPArray2 = string(int(sn1IPArray[2]))
var sn1IPArray1 = string(int(sn1IPArray[1]))
var sn1IPArray0 = string(int(sn1IPArray[0]))
var sn1GatewayIP = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${sn1IPArray3}'
var sn1IPfga = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${(int(sn1IPArray2nd[0]) + 5)}'
var sn1IPfgb = '${sn1IPArray0}.${sn1IPArray1}.${sn1IPArray2}.${(int(sn1IPArray2nd[0]) + 6)}'
var sn2IPArray = split(subnet2Prefix, '.')
var sn2IPArray2ndString = string(sn2IPArray[3])
var sn2IPArray2nd = split(sn2IPArray2ndString, '/')
var sn2CIDRmask = string(int(sn2IPArray2nd[1]))
var sn2IPArray3 = string((int(sn2IPArray2nd[0]) + 1))
var sn2IPArray2 = string(int(sn2IPArray[2]))
var sn2IPArray1 = string(int(sn2IPArray[1]))
var sn2IPArray0 = string(int(sn2IPArray[0]))
var sn2GatewayIP = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${sn2IPArray3}'
var sn2IPlb = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPArray2nd[0]) + 4)}'
var sn2IPfga = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPArray2nd[0]) + 5)}'
var sn2IPfgb = '${sn2IPArray0}.${sn2IPArray1}.${sn2IPArray2}.${(int(sn2IPArray2nd[0]) + 6)}'
var sn3IPArray = split(subnet3Prefix, '.')
var sn3IPArray2ndString = string(sn3IPArray[3])
var sn3IPArray2nd = split(sn3IPArray2ndString, '/')
var sn3CIDRmask = string(int(sn3IPArray2nd[1]))
var sn3IPArray2 = string(int(sn3IPArray[2]))
var sn3IPArray1 = string(int(sn3IPArray[1]))
var sn3IPArray0 = string(int(sn3IPArray[0]))
var sn3IPfga = '${sn3IPArray0}.${sn3IPArray1}.${sn3IPArray2}.${(int(sn3IPArray2nd[0]) + 5)}'
var sn3IPfgb = '${sn3IPArray0}.${sn3IPArray1}.${sn3IPArray2}.${(int(sn3IPArray2nd[0]) + 6)}'
var sn4IPArray = split(subnet4Prefix, '.')
var sn4IPArray2ndString = string(sn4IPArray[3])
var sn4IPArray2nd = split(sn4IPArray2ndString, '/')
var sn4CIDRmask = string(int(sn4IPArray2nd[1]))
var sn4IPArray3 = string((int(sn4IPArray2nd[0]) + 1))
var sn4IPArray2 = string(int(sn4IPArray[2]))
var sn4IPArray1 = string(int(sn4IPArray[1]))
var sn4IPArray0 = string(int(sn4IPArray[0]))
var sn4GatewayIP = '${sn4IPArray0}.${sn4IPArray1}.${sn4IPArray2}.${sn4IPArray3}'
var sn4IPfga = '${sn4IPArray0}.${sn4IPArray1}.${sn4IPArray2}.${(int(sn4IPArray2nd[0]) + 5)}'
var sn4IPfgb = '${sn4IPArray0}.${sn4IPArray1}.${sn4IPArray2}.${(int(sn4IPArray2nd[0]) + 6)}'
var internalLBName = '${fortiGateNamePrefix}-InternalLoadBalancer'
//var internalLBId = internalLB.id
var internalLBFEName = '${fortiGateNamePrefix}-ILB-${subnet2Name}-FrontEnd'
var internalLBFEId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations/', internalLBName, internalLBFEName)
var internalLBBEName = '${fortiGateNamePrefix}-ILB-${subnet2Name}-BackEnd'
var internalLBBEId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools/', internalLBName, internalLBBEName)
var internalLBProbeName = 'lbprobe'
var internalLBProbeId = resourceId('Microsoft.Network/loadBalancers/probes/', internalLBName, internalLBProbeName)
var externalLBName = '${fortiGateNamePrefix}-ExternalLoadBalancer'
//var externalLBId = externalLB.id
var externalLBFEName = '${fortiGateNamePrefix}externalLBFE'
var externalLBFEId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations/', externalLBName, externalLBFEName)
var externalLBBEName = '${fortiGateNamePrefix}externalLBBE'
var externalLBBEId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools/', externalLBName, externalLBBEName)
var externalLBProbeName = 'lbprobe'
var externalLBProbeId = resourceId('Microsoft.Network/loadBalancers/probes/', externalLBName, externalLBProbeName)

module pid_2dc4b447_552f_557f_b1cc_2faec6f9f133 './nested_pid_2dc4b447_552f_557f_b1cc_2faec6f9f133.bicep' = {
  name: 'pid-2dc4b447-552f-557f-b1cc-2faec6f9f133'
  params: {}
}

resource compute_AvailabilitySet_FG 'Microsoft.Compute/availabilitySets@2023-03-01' = {
  name: compute_AvailabilitySet_FG_Name
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 2
  }
  sku: {
    name: 'Aligned'
  }
}

resource routeTableProtectedA 'Microsoft.Network/routeTables@2022-11-01' = {
  name: routeTableProtectedAName
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    routes: [
      {
        name: 'VirtualNetwork'
        properties: {
          addressPrefix: vnetAddressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
      {
        name: 'Subnet'
        properties: {
          addressPrefix: subnet5Prefix
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
    ]
  }
}

resource routeTableProtectedB 'Microsoft.Network/routeTables@2022-11-01' = {
  name: routeTableProtectedBName
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    routes: [
      {
        name: 'VirtualNetwork'
        properties: {
          addressPrefix: vnetAddressPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
      {
        name: 'Subnet'
        properties: {
          addressPrefix: subnet6Prefix
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
    ]
  }
}

resource routeTableSpoke1 'Microsoft.Network/routeTables@2022-11-01' = {
  name: routeTableSpoke1Name
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    routes: [
      {
        name: 'VirtualNetwork'
        properties: {
          addressPrefix: vnetAddressPrefixSpoke1
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
      {
        name: 'Subnet'
        properties: {
          addressPrefix: subnet1Spoke1Prefix
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
    ]
  }
}

resource routeTableSpoke2 'Microsoft.Network/routeTables@2022-11-01' = {
  name: routeTableSpoke2Name
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  location: location
  properties: {
    routes: [
      {
        name: 'VirtualNetwork'
        properties: {
          addressPrefix: vnetAddressPrefixSpoke2
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
      {
        name: 'Subnet'
        properties: {
          addressPrefix: subnet1Spoke2Prefix
          nextHopType: 'VnetLocal'
        }
      }
      {
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: sn2IPlb
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' = if (vnetNewOrExisting == 'new') {
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
        }
      }
      {
        name: subnet4Name
        properties: {
          addressPrefix: subnet4Prefix
        }
      }
      {
        name: subnet5Name
        properties: {
          addressPrefix: subnet5Prefix
          routeTable: {
            id: routeTableProtectedAId
          }
        }
      }
      {
        name: subnet6Name
        properties: {
          addressPrefix: subnet6Prefix
          routeTable: {
            id: routeTableProtectedBId
          }
        }
      }
    ]
  }
  
}

resource vnetName_hubtoSpoke1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = if (vnetNewOrExisting == 'new') {
  parent: vnet
  name: hubtoSpoke1PeeringName
  //location: location
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetIdSpoke1
    }
  }
}

resource vnetName_hubtoSpoke2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = if (vnetNewOrExisting == 'new') {
  parent: vnet
  name: hubtoSpoke2PeeringName
  //location: location
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetIdSpoke2
    }
  }
}

resource vnetNameSpoke1_resource 'Microsoft.Network/virtualNetworks@2022-11-01' = if (vnetNewOrExistingSpoke1 == 'new') {
  name: vnetNameSpoke1var
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefixSpoke1
      ]
    }
    subnets: [
      {
        name: subnet1Spoke1Name
        properties: {
          addressPrefix: subnet1Spoke1Prefix
          routeTable: {
            id: routeTableSpoke1Id
          }
        }
      }
    ]
  }
  
}

resource vnetNameSpoke1_spoke1toHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = if (vnetNewOrExistingSpoke1 == 'new') {
  parent: vnetNameSpoke1_resource
  name: spoke1toHubPeeringName
  //location: location
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetId
    }
  }
}

resource vnetNameSpoke2_resource 'Microsoft.Network/virtualNetworks@2022-11-01' = if (vnetNewOrExistingSpoke2 == 'new') {
  name: vnetNameSpoke2var
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefixSpoke2
      ]
    }
    subnets: [
      {
        name: subnet1Spoke2Name
        properties: {
          addressPrefix: subnet1Spoke2Prefix
          routeTable: {
            id: routeTableSpoke2Id
          }
        }
      }
    ]
  }
}

resource vnetNameSpoke2_spoke2toHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = if (vnetNewOrExistingSpoke2 == 'new') {
  parent: vnetNameSpoke2_resource
  name: spoke2toHubPeeringName
  //location: location
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vnetId
    }
  }
}

resource internalLB 'Microsoft.Network/loadBalancers@2022-11-01' = {
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
        name: 'lbruleFE2all'
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
        name: internalLBProbeName
      }
    ]
  }
  dependsOn: [
    vnet
  ]
}

resource NSG 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: NSGName
  location: location
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

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-11-01' = if (publicIPNewOrExisting == 'new') {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: publicIPNamevar
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource publicIP2 'Microsoft.Network/publicIPAddresses@2022-11-01' = if (publicIP2NewOrExisting == 'new') {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: publicIP2Namevar
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource publicIP3 'Microsoft.Network/publicIPAddresses@2022-11-01' = if (publicIP3NewOrExisting == 'new') {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: publicIP3Namevar
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource externalLB 'Microsoft.Network/loadBalancers@2022-11-01' = {
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
            id: publicIPId
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
        name: 'PublicLBRule-FE1-http'
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
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
        }
        name: 'PublicLBRule-FE1-udp10551'
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
        name: externalLBProbeName
      }
    ]
  }
  
}

resource fgaNic1 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic1Name
  location: location
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
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnet
  ]
}

resource fgbNic1 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic1Name
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
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnet
  ]
}

resource fgaNic2 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn2IPfga
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
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnet
    internalLB
  ]
}

resource fgbNic2 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn2IPfgb
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
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnet
    internalLB

  ]
}

resource fgaNic3 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic3Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn3IPfga
          subnet: {
            id: subnet3Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnet
  ]
}

resource fgbNic3 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic3Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn3IPfgb
          subnet: {
            id: subnet3Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnet
  ]
}

resource fgaNic4 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgaNic4Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn4IPfga
          publicIPAddress: {
            id: publicIP2Id
          }
          subnet: {
            id: subnet4Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnet
  ]
}

resource fgbNic4 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  name: fgbNic4Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: sn4IPfgb
          publicIPAddress: {
            id: publicIP3Id
          }
          subnet: {
            id: subnet4Id
          }
        }
      }
    ]
    enableIPForwarding: true
    enableAcceleratedNetworking: acceleratedNetworking
    networkSecurityGroup: {
      id: NSGId
    }
  }
  dependsOn: [
    vnet
  ]
}

resource fgaVm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: fgaVmName
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  plan: {
    name: fortiGateImageSKU
    publisher: imagePublisher
    product: imageOffer
  }
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    availabilitySet: {
      id: compute_AvailabilitySet_FG_Id
    }
    osProfile: {
      computerName: fgaVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: fgaCustomData
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: fortiGateImageSKU
        version: fortiGateImageVersion
      }
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
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled:true
      }
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
        {
          properties: {
            primary: false
          }
          id: fgaNic3Id
        }
        {
          properties: {
            primary: false
          }
          id: fgaNic4Id
        }
      ]
    }
  }
  
}

resource fgbVm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: fgbVmName
  tags: {
    provider: toUpper(fortinetTags.provider)
  }
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  plan: {
    name: fortiGateImageSKU
    publisher: imagePublisher
    product: imageOffer
  }
  properties: {
    hardwareProfile: {
      vmSize: instanceType
    }
    availabilitySet: {
      id: compute_AvailabilitySet_FG_Id
    }
    osProfile: {
      computerName: fgbVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: fgbCustomData
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: fortiGateImageSKU
        version: fortiGateImageVersion
      }
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
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled:true
      }
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
        {
          properties: {
            primary: false
          }
          id: fgbNic3Id
        }
        {
          properties: {
            primary: false
          }
          id: fgbNic4Id
        }
      ]
    }
  }
  
}
