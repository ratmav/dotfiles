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

    info "configure git to use lf, not crlf, line endings"
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

# TODO: can we avoid admin? see https://wezfurlong.org/wezterm/config/files.html
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

function install_chocolatey {
  warn "admin privileges required."

  if (commandExists -Command "choco") {
    warn "chocolatey already installed"
  } else {
    Set-ExecutionPolicy Bypass `
      -Scope Process `
      -Force; `
      [System.Net.ServicePointManager]::SecurityProtocol = `
      [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
      iex ((New-Object System.Net.WebClient).`
      DownloadString('https://chocolatey.org/install.ps1'))
  }
}

function install_tools {
  warn "admin privileges required."

  if (commandExists -Command "choco") {
    $tools = @(
      'psscriptanalyzer', 'wezterm', 'neovim', 'pandoc', 'yq', 'jq'
      )
    foreach ($tool in $tools) {
      if (choco list --localonly | Select-String $tool) {
        warn "${tool} already installed"
      } else {
        choco install $tool --yes
      }
    }
  } else {
    die "chocolatey not installed"
  }
}
