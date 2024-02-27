<# Script to add full mailbox permission for one user to multiple mailboxes #>
#Connect to Exchange online first

'user1@email.com.au','user2@email.com.au' | Get-Mailbox | Add-MailboxPermission -User userneedingfullaccess@email.com -AccessRights FullAccess -AutoMapping $false3
