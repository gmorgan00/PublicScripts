<#
=========================================================================================================================
Required - Powershell Version 5.1 
=========================================================================================================================
.SYNOPSIS

.DESCRIPTION
Used with Azyre Automation to report on expiry of App reg secrets and certificates            
#>

try {
    Connect-AzAccount -Identity | Out-Null
} catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

$objects = @()
$appRegistrations = Get-AzADApplication | Select-Object -Property AppId, DisplayName, PasswordCredentials, keyCredentials

foreach ($app in $appRegistrations) {    
    $secrets = @()
    foreach ($secret in $app.PasswordCredentials) {        
        $secrets += @{ "Name" = $secret.DisplayName; "StartDateTime" = $secret.StartDateTime.ToString("MM/dd/yyyy"); "EndDateTime" = $secret.EndDateTime.ToString("MM/dd/yyyy"); "RemainingDays" = ($secret.EndDateTime - (Get-Date)).Days  }
    }
    $certificates = @()
    foreach ($certficate in $app.KeyCredentials) {        
        $certificates += @{ "Name" = $certficate.DisplayName; "StartDateTime" = $certficate.StartDateTime.ToString("MM/dd/yyyy"); "EndDateTime" = $certficate.EndDateTime.ToString("MM/dd/yyyy"); "RemainingDays" = ($certficate.EndDateTime - (Get-Date)).Days  }
    }
    $objects += @{ "AppId" = $app.AppId; "DisplayName" = $app.DisplayName; Secrets = $secrets; Certificates = $certificates}

}
$tbody = @()
foreach ($obj in $objects) { 
    $approw = $null
    $secretsrow = $null
    $certsrow = $null

    $approw += '
        <tr>
            <td style="border: 1px solid black; width: 12.4818%;"><strong>Application ID</strong></td>
            <td style="border: 1px solid black; width: 75%;" colspan="3">' + $obj.AppId + '</td>
        </tr>
        <tr>
            <td style="border: 1px solid black; width: 12.4818%;"><strong>Name</strong></td>
            <td style="border: 1px solid black; width: 75%;" colspan="3">' + $obj.DisplayName + '</td>
        </tr>'

    
    if ($obj.Secrets.Count -le 0) {
        $secretsrow += '
            <tr style="text-align: center;">
                <td style="border: 1px solid black; width: 100%;" colspan="4">No records found.</td>
            </tr>'
    } else {
        foreach ($secret in $obj.Secrets) { 
            $secretsrow += '
            <tr style="text-align: center;">
                <td style="border: 1px solid black; width: 12.4818%;">' + $secret.Name + '</td>
                <td style="border: 1px solid black; width: 12.4818%;">' + $secret.StartDateTime + '</td>
                <td style="border: 1px solid black; width: 12.4818%;">' + $secret.EndDateTime + '</td>
                <td style="border: 1px solid black; width: 12.4818%;">' + $(if([int]$secret.RemainingDays -le 0) { '<span style="color: rgb(184, 49, 47);">' + $secret.RemainingDays + '</span>' } else { $secret.RemainingDays }) + '</td>
            </tr>'
        }
    }

    if ($obj.Certificates.Count -le 0) {
        $certsrow += '
             <tr style="text-align: center;">
                <td style="border: 1px solid black; width: 100%;" colspan="4">No records found.</td>
            </tr>'
    } else {
        foreach ($cert in $obj.Certificates) { 
            $certsrow += '
            <tr style="text-align: center;">
                <td style="border: 1px solid black; width: 12.4818%;">' + $cert.Name + '</td>
                <td style="border: 1px solid black; width: 12.4818%;">' + $cert.StartDateTime + '</td>
                <td style="border: 1px solid black; width: 12.4818%;">' + $cert.EndDateTime + '</td>
                <td style="border: 1px solid black; width: 12.4818%;">' + $(if([int]$cert.RemainingDays -le 0) { '<span style="color: rgb(184, 49, 47);">' + $cert.RemainingDays + '</span>' } else { $cert.RemainingDays }) + '</td>
            </tr>'
        }
    }
   
    $tbody += '<table style="width: 90%;border-collapse: collapse"><tbody> ' + $approw + '
        <tr style="text-align: center; border: 1px solid black; width: 62.5547%; background-color: rgb(0, 0, 0);">
            <td colspan="4">
                <div style="text-align: center;"><strong><span style="color: rgb(255, 255, 255);">Secrets List</span></strong></div>
            </td>
        </tr>
        <tr style="text-align: center;">
            <td style="border: 1px solid black; width: 12.4818%;">
                <div><strong>Name</strong></div>
            </td>
            <td style="border: 1px solid black; width: 12.4818%;">
                <div>&nbsp;<strong>Start Date Time</strong></div>
            </td>
            <td style="border: 1px solid black; width: 12.4818%;">
                <div><strong>End Date Time</strong></div>
            </td>
            <td style="border: 1px solid black; width: 12.4818%;">
                <div><strong>Remaining Day(s)</strong></div>
            </td>
        </tr> ' + $secretsrow  + '
        <tr style="text-align: center; border: 1px solid black; width: 62.5547%; background-color: rgb(0, 0, 0);">
            <td colspan="4">
                <div style="text-align: center;"><strong><span style="color: rgb(255, 255, 255);">Certificates List</span></strong></div>
            </td>
        </tr>
        <tr style="text-align: center;">
            <td style="border: 1px solid black; width: 12.4818%;">
                <div><strong>Name</strong></div>
            </td>
            <td style="border: 1px solid black; width: 12.4818%;">
                <div>&nbsp;<strong>Start Date Time</strong></div>
            </td>
            <td style="border: 1px solid black; width: 12.4818%;">
                <div><strong>End Date Time</strong></div>
            </td>
            <td style="border: 1px solid black; width: 12.4818%;">
                <div><strong>Remaining Day(s)</strong></div>
            </td>
        </tr> ' + $certsrow  + '
    </tbody></table><br>'          
}
$tbody
