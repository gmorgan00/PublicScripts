Get-Mailbox -resultsize unlimited | Get-MailboxPermission | Select Identity, User, Deny, AccessRights, IsInherited| Export-Csv -Path "c:\temp\mailboxpermissions.csv" –NoTypeInformation
