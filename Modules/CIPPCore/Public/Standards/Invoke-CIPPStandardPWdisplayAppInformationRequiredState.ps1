function Invoke-PWdisplayAppInformationRequiredState {
    <#
    .FUNCTIONALITY
    Internal
    #>
    param($Tenant, $Settings)
    If ($Settings.Remediate) {
        try {
            $body = @'
{"@odata.type":"#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration","id":"MicrosoftAuthenticator","includeTargets":[{"id":"all_users","isRegistrationRequired":false,"targetType":"group","authenticationMode":"any"}],"excludeTargets":[],"state":"enabled","isSoftwareOathEnabled":false,"featureSettings":{"displayLocationInformationRequiredState":{"state":"enabled","includeTarget":{"id":"all_users","targetType":"group","displayName":"All users"}},"displayAppInformationRequiredState":{"state":"enabled","includeTarget":{"id":"all_users","targetType":"group","displayName":"All users"}},"companionAppAllowedState":{"state":"default","includeTarget":{"id":"all_users","targetType":"group","displayName":"All users"}}}}
'@
    (New-GraphPostRequest -tenantid $tenant -Uri 'https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations/microsoftAuthenticator' -Type patch -Body $body -ContentType 'application/json')
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Enabled passwordless with Information and Number Matching.' -sev Info
        } catch {
            Write-LogMessage -API 'Standards' -tenant $tenant -message "Failed to enable passwordless with Information and Number Matching. Error: $($_.exception.message)" -sev 'Error'
        }
    }
    if ($Settings.Alert) {
        $CurrentInfo = New-GraphGetRequest -Uri 'https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations/microsoftAuthenticator' -tenantid $Tenant
        if ($CurrentInfo.featureSettings.displayAppInformationRequiredState.state -eq 'enabled') {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Passwordless with Information and Number Matching is enabled.' -sev Info
        } else {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Passwordless with Information and Number Matching is not enabled.' -sev Alert
        }
    }
}
