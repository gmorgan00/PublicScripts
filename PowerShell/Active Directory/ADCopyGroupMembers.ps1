<# Script to copy members from one AD Security Group to another #>

#List group members from first group
Get-ADGroupMember -Identity "Security Group 1" | Select-Object Name | Sort-Object Name

#Get group members from first group and add to second group
Get-ADGroupMember -Identity "Security Group 1" | ForEach-Object {Add-ADGroupMember -Identity "Security Group 2" -Members $_.distinguishedName}

#Confirm members added to second group
Get-ADGroupMember -Identity "Security Group 2" | Select-Object Name | Sort-Object Name
