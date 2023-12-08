function Invoke-DeletedUserRentention {
    <#
    .FUNCTIONALITY
    Internal
    #>
    param($Tenant, $Settings)
    If ($Settings.Remediate) {
        try {
            $body = '{"deletedUserPersonalSiteRetentionPeriodInDays": 365}'
            New-GraphPostRequest -tenantid $tenant -Uri 'https://graph.microsoft.com/beta/admin/sharepoint/settings' -AsApp $true -Type PATCH -Body $body -ContentType 'application/json'

            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Set deleted user rentention of OneDrive to 1 year' -sev Info
        } catch {
            Write-LogMessage -API 'Standards' -tenant $tenant -message "Failed to set deleted user rentention of OneDrive to 1 year: $($_.exception.message)" -sev Error
        }
    }
    if ($Settings.Alert) {
        $CurrentInfo = New-GraphGetRequest -Uri 'https://graph.microsoft.com/beta/admin/sharepoint/settings' -tenantid $Tenant -AsApp $true
        if ($CurrentInfo.deletedUserPersonalSiteRetentionPeriodInDays -eq 365) {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Deleted user rentention of OneDrive is set to 1 year' -sev Info
        } else {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Deleted user rentention of OneDrive is not set to 1 year' -sev Alert
        }
    }
}
