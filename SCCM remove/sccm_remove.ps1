 
# Stop Services
Stop-Service -Name ccmsetup -Force -ErrorAction SilentlyContinue
Stop-Service -Name CcmExec -Force -ErrorAction SilentlyContinue
Stop-Service -Name smstsmgr -Force -ErrorAction SilentlyContinue
Stop-Service -Name CmRcService -Force -ErrorAction SilentlyContinue

# Uninstall SCCM
c:\windows\ccmsetup\ccmsetup.exe /uninstall
# Remove WMI Namespaces
Get-WmiObject -Query "SELECT * FROM __Namespace WHERE Name='ccm'" -Namespace root | Remove-WmiObject -ErrorAction SilentlyContinue
Get-WmiObject -Query "SELECT * FROM __Namespace WHERE Name='sms'" -Namespace root\cimv2 | Remove-WmiObject -ErrorAction SilentlyContinue

# Remove Services from Registry
$MyPath = "HKLM:\SYSTEM\CurrentControlSet\Services"
Remove-Item -Path $MyPath\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\CcmExec -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\smstsmgr -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\CmRcService -Force -Recurse -ErrorAction SilentlyContinue

# Remove SCCM Client from Registry
$MyPath = "HKLM:\SOFTWARE\Microsoft"
Remove-Item -Path $MyPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\SMS -Force -Recurse -ErrorAction SilentlyContinue

# Remove Folders and Files
$MyPath = $env:WinDir
Remove-Item -Path $MyPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\ccmsetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\ccmcache -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\SMSCFG.ini -Force -ErrorAction SilentlyContinue
Remove-Item -Path $MyPath\SMS*.mif -Force -ErrorAction SilentlyContinue


# Set registry to AutoEnroll by UserCredentials to intune
cmd /c 'REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" /v AutoEnrollMDM /t REG_DWORD /d 1 /f' 
cmd /c 'REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" /v UseAADCredentialType /t REG_DWORD /d 1 /f' 
# Run AutoEnroll
c:\windows\system32\deviceenroller.exe /c /AutoEnrollMDM