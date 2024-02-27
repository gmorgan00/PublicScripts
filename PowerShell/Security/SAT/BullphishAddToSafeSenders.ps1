<# Add Phishing simulation senders to safe list in Outlook for BullPhish SAT #>

$users = Get-EXOMailbox
$senders = "bp-service-support.com","bp-securityawareness.com","online-account.info",
"myonlinesecuritysupport.com","service-noreply.info","banking-alerts.info","bullphish.com",
"verifyaccount.help","suspected-fraud.info"
foreach($user in $users){
$out = 'Adding Trusted Senders to {0}' -f $user.UserPrincipalName
Write-Output $out
Set-MailboxJunkEmailConfiguration $user.UserPrincipalName -TrustedSendersAndDomains @{Add=$senders}
}
Write-Output "Finished!"
