$WinPath = $env:WinDir
$ccmSetupPath = "$WinPath\ccmsetup\ccmsetup.exe"
# Check if the file exists
if (Test-Path $ccmSetupPath) {
    # If the file exists, run the uninstall command
    Start-Process -FilePath $ccmSetupPath -ArgumentList "/uninstall" -Wait
    Write-Output "ccmsetup.exe has been uninstalled."
} 

#running ccmclean
.\ccmclean.exe /q 
Start-Sleep -Seconds 10

# Remove Folders and Files
Remove-Item -Path $WinPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $WinPath\ccmsetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $WinPath\ccmcache -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $WinPath\SMSCFG.ini -Force -ErrorAction SilentlyContinue
Remove-Item -Path $WinPath\SMS*.mif -Force -ErrorAction SilentlyContinue

# Remove SCCM Client from Registry
$RegPath = “HKLM:\SOFTWARE\Microsoft”
Remove-Item -Path $RegPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $RegPath\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue


# Registry for Autoenroll
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" -Name AutoEnrollMDM -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" -Name UseAADCredentialType -Value 1 -Type DWord -Force

#run deviceenroller task
$DVenr = "$env:WinDir\system32\deviceenroller.exe"
Start-Process -FilePath $DVenr  -ArgumentList "/c /AutoEnrollMDM"

#create ccm_removed.txt
$filePath = "$WinPath\ccm_removed.txt"
Set-Content -Path $filePath -Value "Finished"

