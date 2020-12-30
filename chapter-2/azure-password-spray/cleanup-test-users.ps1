$domainName = ((Get-AzureAdTenantDetail).VerifiedDomains)[0].Name
$users = "sandra@$domainName","mike@$domainName","juan@$domainName","kwasi@$domainName","adaeze@$domainName"

foreach ($user in $users) 
{
    Remove-AzADUser -UserPrincipalName $user -Confirm:$False -Force
    echo "Successfully deleted $user"
}
echo "Test users successfully cleaned up"