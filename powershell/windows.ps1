function autostart_komorebi {
  if (commandExists -Command "komorebic") {
    $linkPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\komorebi.lnk"
    Remove-Item -Force -ErrorAction Ignore $linkPath
    $shell = New-Object -comObject WScript.Shell
    $shortcut = $shell.CreateShortcut($linkPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = '-WindowStyle hidden -Command komorebic start --await-configuration'
    $shortcut.Save()
    info "linked komorebi to run on startup"
  } else {
    die "komorebi not installed"
  }
}

function configure_git {
  if (commandExists -Command "git") {
    git config --global core.excludesfile "${pwd}\.gitignore_global"
    info "configured global gitignore"

    if (commandExists -Command "nvim") {
      git config --global core.editor $(Get-Command nvim).Source
      info "configured git editor"
    } else {
      die "neovim not installed"
    }

    git config core.eol lf
    git config core.autocrlf input
    git config --global core.eol lf
    git config --global core.autocrlf input
    info "configured git to use lf, not crlf, line endings"
  } else {
    die "git not installed"
  }
}

function configure_komorebi {
  if (commandExists -Command "komorebic") {
    $komorebiAppConfig = "$env:USERPROFILE\komorebi.generated.ps1"
    Remove-Item -Force -ErrorAction Ignore $komorebiAppConfig
    Copy-Item .\powershell\komorebi.generated.ps1 $komorebiAppConfig
    info "(re)wrote komorebi app config"

    $komorebiConfig = "$env:USERPROFILE\komorebi.ps1"
    Remove-Item -Force -ErrorAction Ignore $komorebiConfig
    Copy-Item .\powershell\komorebi.ps1 $komorebiConfig
    info "(re)wrote komorebi config"

    $configDir  = "$env:USERPROFILE\.config"
    # NOTE: do not destroy/recreate config dir; may be used by other programs.
    if(!(test-path -PathType container $configDir)) {
      New-Item -ItemType Directory -Path $configDir
    }
    Remove-Item -Force -ErrorAction Ignore $configDir\whkdrc
    Copy-Item .\whkdrc $configDir\whkdrc
    info "(re)wrote whkd config"
  } else {
    die "komorebi not installed"
  }
}

function configure_nvim {
  if (commandExists -Command "nvim") {
    $nvimInit = "$env:USERPROFILE\AppData\Local\nvim"
    Remove-Item -Recurse -Force -ErrorAction Ignore $nvimInit
    New-Item -Path $nvimInit -ItemType "directory" | Out-Null
    Copy-Item .\init.vim $nvimInit\init.vim
    info "(re)wrote nvim config"


    $nvimData = "$env:USERPROFILE\AppData\Local\nvim-data"
    Remove-Item -Recurse -Force -ErrorAction Ignore $nvimData
    $nvimAutoload = "${nvimData}\site\autoload"
    New-Item -Path $nvimAutoload -ItemType "directory" | Out-Null
    $vimPlugUrl = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    Invoke-WebRequest -Uri $vimPlugUrl -OutFile "${nvimAutoload}\plug.vim"
    info "(re)installed vim-plug"

    nvim +PlugInstall +qall
    info "(re)installed nvim plugins"
  } else {
    die "nvim not installed"
  }
}

function configure_wez {
  warn "admin privileges required."

  if (commandExists -Command "wezterm") {
    $wezConfig = "C:\Program Files\WezTerm\wezterm.lua"
    Remove-Item -Force -ErrorAction Ignore $wezConfig
    Copy-Item .\wezterm.lua $wezConfig
    info "wrote wez config"
  } else {
    die "wezterm not installed"
  }
}

function install_psscriptanalyzer {
  Start-Process `
    -FilePath "powershell" `
    -Verb runAs `
    -ArgumentList "Install-Module -Name PSScriptAnalyzer -Force"
  info "(re)installed psscriptanalyzer"
}

function winget_packages {
  if (commandExists -Command "winget") {
    $tools = @(
      "sysinternals",
      "wezterm",
      "neovim",
      "pandoc",
      "LGUG2Z.whkd",
      "LGUG2Z.komorebi"
      )
    foreach ($tool in $tools) {
      winget list --name $tool
      if ($LASTEXITCODE -eq 0) {
        warn "${tool} already installed"
      } else {
        winget install ${tool} `
          --accept-package-agreements `
          --accept-source-agreements
        info "installed ${tool}"
      }
    }
  } else {
    die "winget not installed"
  }
}
