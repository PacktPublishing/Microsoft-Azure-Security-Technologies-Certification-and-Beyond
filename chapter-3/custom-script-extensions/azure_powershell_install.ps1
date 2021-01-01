Uninstall-AzureRm -Confirm:$False
Install-Module -Name Az -AllowClobber -Force -Confirm:$False
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install python3 --pre -y
choco install httpie pip choco install 7zip.install -y

