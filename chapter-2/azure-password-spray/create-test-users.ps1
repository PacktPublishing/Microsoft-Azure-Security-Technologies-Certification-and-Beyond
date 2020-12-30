Connect-AzureAD
$passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$passwordProfile.Password = Read-Host "Please enter a password"
$domainName = ((Get-AzureAdTenantDetail).VerifiedDomains)[0].Name
$users = "sandra@$domainName","mike@$domainName","juan@$domainName","kwasi@$domainName","adaeze@$domainName"

foreach ($user in $users) 
{ 
$displayname=$(echo $user | sed 's/@.*//')
New-AzureADUser -DisplayName $displayname -UserPrincipalName $user -PasswordProfile $passwordProfile -MailNickname $displayname -AccountEnabled $true

}
echo "Successfully created the following users:" $users
echo "User Password:" $passwordProfile.Password