param(
[string] $chefServerUserName = "$1",
[string] $adminPassword = "$2",
[string] $ChefServerFqdn = "$3",
[string] $organizationName= "$4",
[string] $nodesAdminUsername= "$5",
[string] $wsAdminUsername= "$6",
[string] $wsNodeFqdn= "$7",
[string] $envNode0Fqdn= "$8",
[string] $envNode1Fqdn= "${9}",
[string] $envNode2Fqdn= "${10}"
)
$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
. { iwr -useb https://omnitruck.chef.io/install.ps1 } | iex; install -project chefdk -channel stable -version 2.0.26
Invoke-WebRequest -Uri https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.70-installer.msi -OutFile c:/users/Putty.msi 
Start-Process c:/Users/Putty.msi   /qn -Wait
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  -Force
chef generate app c:\Users\chef-repo
echo c:\Users\chef-repo\.chef\knife.rb | knife configure --server-url https://$ChefServerFqdn/organizations/$organizationName/ --validation-client-name $organizationName-validator --validation-key c:/Users/chef-repo/.chef/$organizationName-validator.pem --user $chefServerUserName --repository c:/Users/chef-repo
echo n | & "C:\Program Files\PuTTY\pscp.exe"  -scp -pw $adminPassword chefuser@$ChefServerFqdn:/etc/opscode/chefautomatedeliveryuser.pem C:\Users\chef-repo\.chef\$chefServerUserName".pem"
echo n | & "C:\Program Files\PuTTY\pscp.exe"  -scp -pw $adminPassword chefuser@$ChefServerFqdn:/etc/opscode/chef-automate-org-validator.pem C:\Users\chef-repo\.chef\$organizationName".pem"
knife bootstrap windows winrm $wsNodeFqdn --config c:\Users\chef-repo\.chef\knife.rb -x $wsAdminUsername -P $adminPassword -N chefwsnode --node-ssl-verify-mode none
knife bootstrap $envNode0Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefenvnode0 --node-ssl-verify-mode none
knife bootstrap $envNode1Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefenvnode1 --node-ssl-verify-mode none
knife bootstrap $envNode2Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefenvnode2 --node-ssl-verify-mode none
