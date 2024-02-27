<# Script to add full mailbox permission for one user to multiple mailboxes #>
#Connect to Exchange online first

'<MailboxIdentity>','<MailboxIdentity>' | Get-Mailbox | Add-MailboxPermission -User <MailboxIdentityOfPersonNeedingFullAccess> -AccessRights FullAccess -AutoMapping $false

#Check mailbox permission after

Get-MailboxPermission -Identity <MailboxIdentity> | Format-List
