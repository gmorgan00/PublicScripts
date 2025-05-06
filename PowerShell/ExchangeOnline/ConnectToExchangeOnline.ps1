<# Connect to Exchange online #>

Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName <upn>

<#Disconnect from Exchange Online#>
Disconnect-ExchangeOnline -Confirm:$false

