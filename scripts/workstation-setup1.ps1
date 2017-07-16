Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)
. { iwr -useb https://omnitruck.chef.io/install.ps1 } | iex; install -project chefdk -channel stable -version 2.0.26
setx PATH "$env:path;C:\opscode\chefDK\embedded\bin\" -m
Invoke-WebRequest -Uri https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.70-installer.msi -OutFile c:/users/Putty.msi 
Start-Process c:/Users/Putty.msi   /qn -Wait
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  -Force
Restart-computer workstation
