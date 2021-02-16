Import-Module -Force .\Modules\Windows\Windows.psm1

# TODO: symlink powershell profile to C:\Users\ratma\Documents\WindowPowershell\Microsoft.PowerShell_profile.ps1 and enable choco tab completion.

function Main {
  Initialize-Windows
}

Main