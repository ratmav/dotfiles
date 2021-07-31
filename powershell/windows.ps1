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
  $tools = @('pandoc', 'yq', 'jq')
  foreach ($tool in $tools) {
    if (commandExists -Command $tool) {
      warn "${tool} already installed"
    } else {
      choco install $tool --yes
    }
  }
}
