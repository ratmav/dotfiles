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

    git config --global push.autoSetupRemote true
    info "configured git to automatically setup remote branches on push"
  } else {
    die "git not installed"
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
  if (commandExists -Command "wezterm") {
    $wezConfig = "$env:USERPROFILE\.config\WezTerm\wezterm.lua"
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
      "pandoc"
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
