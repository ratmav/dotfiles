function Chocolatey {
  Write-Host "...checking chocolatey install"
  if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
    Write-Host "......chocolatey already installed"  
  } else {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "......installed chocolatey"
  }
}

function Choco-Packages {
  $packages = @("git", "neovim")
  Foreach ($package in $packages) {
    Write-Host "...checking $package install"
    if(choco list --localonly | Where-Object {$_ -match $package}) {
      Write-Host "......${package} already installed"
    } else {
      choco install --confirm $package 
      Write-Host "......installed ${package}"
    }
  }
}

function Initialize-Windows {
  Chocolatey
  Choco-Packages
  Write-Host "...done; restart the shell"
}

Export-ModuleMember -Function Initialize-Windows