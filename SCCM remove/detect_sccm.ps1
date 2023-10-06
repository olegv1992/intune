$ccmInstalled = Get-ItemProperty HKLM:\Software\Microsoft\CCM -ErrorAction SilentlyContinue

# Check the installation status
if ($ccmInstalled -ne $null) {
    Write-Output "SCCM Client is installed."
    exit 1 # SCCM Client installed on the system
} else {
    Write-Output "SCCM Client is not installed."
    exit 0 # SCCM Client is not installed on the system
}