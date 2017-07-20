param(
[string] $chefServerUserName = "$1",
[string] $adminPassword = "$2",
[string] $ChefServerFqdn = "$3",
[string] $organizationName= "$4",
[string] $nodesAdminUsername= "$5",
[string] $wsAdminUsername= "$6",
[string] $wsNodeFqdn= "$7",
[string] $envNode0Fqdn= "$8",
[string] $envNode1Fqdn= "$9",
[string] $envNode2Fqdn= "${10}"
)
Invoke-WebRequest -Uri https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.69-installer.msi -OutFile c:/users/Putty.msi 
Start-Process c:/Users/Putty.msi   /qn -Wait
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  -Force
cd C:\opscode\chefdk\bin
chef generate app c:\Users\chef-repo
echo c:\Users\chef-repo\.chef\knife.rb | knife configure --server-url https://$ChefServerFqdn/organizations/$organizationName/ --validation-client-name $organizationName-validator --validation-key c:/Users/chef-repo/.chef/$organizationName-validator.pem --user $chefServerUserName --repository c:/Users/chef-repo 
Add-Content c:/users/chef-repo/.chef/knife.rb "`nssl_verify_mode    :verify_none"
echo n | & "C:\Program Files\PuTTY\pscp.exe"  -scp -pw $adminPassword chefuser@${ChefServerFqdn}:/etc/opscode/chefautomatedeliveryuser.pem C:\Users\chef-repo\.chef\$chefServerUserName".pem"
echo n | & "C:\Program Files\PuTTY\pscp.exe"  -scp -pw $adminPassword chefuser@${ChefServerFqdn}:/etc/opscode/chef-automate-org-validator.pem C:\Users\chef-repo\.chef\$organizationName".pem"
git clone https://github.com/sysgain/chef-automate-hol-cookbooks.git C:/Users/cookbookstore
cp -r C:/Users/cookbookstore/* C:\Users\chef-repo\cookbooks
knife bootstrap windows winrm $wsNodeFqdn --config c:\Users\chef-repo\.chef\knife.rb -x $wsAdminUsername -P $adminPassword -N chefwinNode --node-ssl-verify-mode none
knife bootstrap $envNode0Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefEnvironment-linuxNode0 --node-ssl-verify-mode none
knife bootstrap $envNode1Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefEnvironment-linuxNode1 --node-ssl-verify-mode none
knife bootstrap $envNode2Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefEnvironment-linuxNode2 --node-ssl-verify-mode none
knife cookbook upload --config c:\Users\chef-repo\.chef\knife.rb --server-url https://$ChefServerFqdn/organizations/$organizationName/ compat_resource audit ohai logrotate sysctl stig
knife node run_list add --config c:\users\chef-repo\.chef\knife.rb --server-url https://$ChefServerFqdn/organizations/$organizationName/ chefEnvironment-linuxNode0 recipe[audit]
knife node run_list add --config c:\users\chef-repo\.chef\knife.rb --server-url https://$ChefServerFqdn/organizations/$organizationName/ chefEnvironment-linuxNode1 recipe[audit]
knife node run_list add --config c:\users\chef-repo\.chef\knife.rb --server-url https://$ChefServerFqdn/organizations/$organizationName/ chefEnvironment-linuxNode2 recipe[audit]
