
$filePath = "$env:WinDir\ccm_removed.txt"
if (Test-Path "$filePath") {
    Write-Host "File detected"
}