## Create victimadminuser
$upnsuffix=$(az ad signed-in-user show --query userPrincipalName --output tsv | sed 's/.*@//')
$password = Read-Host "Please enter a password"
$securepassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$user = "victimadminuser@$upnsuffix"
$displayname=$(echo $user | sed 's/@.*//')
New-AzADUser -DisplayName $displayname -UserPrincipalName $user -Password $securepassword -MailNickname $displayname

## Assign role in Azure subscription
$subid=$(az account show --query id --output tsv)
az role assignment create --role "Contributor" --assignee $user --subscription $subid

## Create Storage account with SAS token
$group = "pentest-rg"
$location = "uksouth"
az group create --name $group --location $location
$random = Get-Random -Maximum 10000
$storagename = "pentest$random"
$containername = "exfil"
$blobname = "azureprofile.zip"
az storage account create --name $storagename --resource-group $group --location $location --sku Standard_LRS --allow-blob-public-access false --https-only true
az storage container create --account-name $storagename --name $containername
$ctx = New-AzStorageContext -StorageAccountName $storagename -UseConnectedAccount
$StartTime = Get-Date
$EndTime = $startTime.AddDays(6)
$sastoken = New-AzStorageContainerSASToken -Name $containername -Permission rwdl -StartTime $StartTime -ExpiryTime $EndTime -context $ctx

## Download Windows Custom Script Extension
Invoke-WebRequest -Uri https://raw.githubusercontent.com/PacktPublishing/Implementing-Microsoft-Azure-Security-Technologies/main/chapter-2/custom-script-extensions/linux_custom_extension.json -OutFile linux_custom_extension.json

## Deploy Windows VM with Azure PowerShell installed (Output public IP)
$winvmname = "linuxvm$random"
$windowsuser = "linuxadmin"
az vm create --resource-group $group --name $winvmname --image win2016datacenter --admin-username $windowsuser --admin-password $password 
az vm open-port --port 3389 --resource-group $group --name $winvmname --priority 200
$winvmpubip=$(az vm show -d -g $group -n $winvmname --query publicIps -o tsv)
az vm extension set -g $group --vm-name $winvmname --name customScript --publisher Microsoft.Azure.Extensions --settings ./linux_custom_extension.json

## Script Output
Write-Host -ForegroundColor Green "Azure Admin User:" $user
Write-Host -ForegroundColor Green "Azure Admin User Password:" $password
Write-Host -ForegroundColor Green " "
Write-Host -ForegroundColor Green "Linux VM Public IP:" $winvmpubip
Write-Host -ForegroundColor Green "Linux VM Username:" $windowsuser
Write-Host -ForegroundColor Green "Linux VM User Password:" $password
Write-Host -ForegroundColor Green " "
Write-Host -ForegroundColor Green "Exfiltration Storage Location: https://$storagename.blob.core.windows.net/$containername/$blobname$sastoken"
