#PowerShell script to assign full access for one user to multiple mailboxes with AutoMapping disabled
#Connect to Exchange online first

'user1 upn','user2 upn' | Get-Mailbox | Add-MailboxPermission -User userneedingfullaccessupn -AccessRights FullAccess -AutoMapping $false3
