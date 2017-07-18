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
chef generate app c:\Users\chef-repo
echo c:\Users\chef-repo\.chef\knife.rb | knife configure --server-url https://$ChefServerFqdn/organizations/$organizationName/ --validation-client-name $organizationName-validator --validation-key c:/Users/chef-repo/.chef/$organizationName-validator.pem --user $chefServerUserName --repository c:/Users/chef-repo 
Add-Content c:/users/chef-repo/.chef/knife.rb "`nssl_verify_mode    :verify_none"
echo n | & "C:\Program Files\PuTTY\pscp.exe"  -scp -pw $adminPassword chefuser@${ChefServerFqdn}:/etc/opscode/chefautomatedeliveryuser.pem C:\Users\chef-repo\.chef\$chefServerUserName".pem"
echo n | & "C:\Program Files\PuTTY\pscp.exe"  -scp -pw $adminPassword chefuser@${ChefServerFqdn}:/etc/opscode/chef-automate-org-validator.pem C:\Users\chef-repo\.chef\$organizationName".pem"
git clone https://github.com/sysgain/chef-automate-hol-cookbooks.git C:/Users/$wsAdminUsername/downloads/cookbooks
cp -r C:/Users/$wsAdminUsername/downloads/cookbooks/* C:\Users\chef-repo\cookbooks
knife bootstrap windows winrm $wsNodeFqdn --config c:\Users\chef-repo\.chef\knife.rb -x $wsAdminUsername -P $adminPassword -N chefwsNode --node-ssl-verify-mode none
knife bootstrap $envNode0Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefEnvironmentNode0 --node-ssl-verify-mode none
knife bootstrap $envNode1Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefEnvironmentNode1 --node-ssl-verify-mode none
knife bootstrap $envNode2Fqdn --config c:\Users\chef-repo\.chef\knife.rb --sudo -x $nodesAdminUsername -P $adminPassword -N chefEnvironmentNode2 --node-ssl-verify-mode none
knife cookbook upload --config c:\Users\chef-repo\.chef\knife.rb --server-url https://$ChefServerFqdn/organizations/$organizationName/ compat_resource audit ohai logrotate sysctl stig
knife node run_list add --config c:\users\chef-repo\.chef\knife.rb --server-url https://$ChefServerFqdn/organizations/$organizationName/ chefEnvironmentNode0 recipe[audit]
knife node run_list add --config c:\users\chef-repo\.chef\knife.rb --server-url https://$ChefServerFqdn/organizations/$organizationName/ chefEnvironmentNode1 recipe[audit]
knife node run_list add --config c:\users\chef-repo\.chef\knife.rb --server-url https://$ChefServerFqdn/organizations/$organizationName/ chefEnvironmentNode2 recipe[audit]
