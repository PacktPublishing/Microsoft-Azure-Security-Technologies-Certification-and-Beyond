$upnsuffix=$(az ad signed-in-user show --query userPrincipalName --output tsv | sed 's/.*@//')
$users = "sandra@$upnsuffix","mike@$upnsuffix","juan@$upnsuffix","kwasi@$upnsuffix","adaeze@$upnsuffix"

foreach ($user in $users) 
{
    Remove-AzADUser -UserPrincipalName $user -Confirm:$False -Force
}
echo "Test users successfully cleaned up"