. .\powershell\windows.ps1

function bootstrap {
  winget_packages
  configure_nvim
  configure_git
  configure_wez
  install_psscriptanalyzer
}

function available {
  Param(
    [string[]] $AvailableFunctions
  )

  warn "function not found. available functions:"
  foreach ($function in $AvailableFunctions) {
    warn "...${function}"
  }
}

function call {
  Param(
    [string] $FunctionName
  )

  $availableFunctions = Get-ChildItem -Name function:\

  if ($FunctionName) {
    if ($availableFunctions.contains($FunctionName)) {
      Invoke-Expression $FunctionName
    } else {
      available $availableFunctions
    }
  } else {
    available $availableFunctions
  }
}

function commandExists {
  Param(
    [string] $Command
  )

  $oldErrorActionPreference = $ErrorActionPreference

  try{
    if (Get-Command $Command) {
      return $true
    }
  } catch {
    return $false
  } finally {
    $ErrorActionPreference = $oldErrorActionPreference
  }
}

function die {
  Param(
    [string] $Message
  )

  Write-Host $Message -ForegroundColor Red
  exit
}

function info {
  Param(
    [string] $Message
  )

  Write-Host $Message
}

function usage {
@"

                            .:
                            :.
                         :oo::.
           ..       ...:oOOOoo: ....           :
           oOOo::o::ooOOOOOoOO. .: .o::...:...::
           .:oo: :..:O8O:.  Oo   .  oOOOOOOOOOO:
          .oo8o. ....::Oo.  O8:     o8O8888O....
         .oOO8O.  ..::.:O:  :O:     :OOoo:.  .:O.
        .ooooo.    :OO: .:  :::::  .ooo:    o::..:
     .oooo:oo:.     .::::oOooOOOO:.:o.    .O8.   o:
   .:o:...    .   :::::oOOOOoooOOOOo::  .oo::   :Ooo:
  :O8O.      .o:.:oOOOoooo::o:::OOO:.oo:OOo    ::OOOOOo.
   .ooo::     .oOo:oOOoo::ooo: .:o::..ooo.     . .:OOO8OOo..
   .oO88O:o:  ooo::oo:ooo:::...:::..::::::        ..:ooo::
   .:O88OOOO:oOoOOoo:oo:oooo:.. .:..:oOOo.:..:.    ......
   .:oo:.   .:Oo:oooooooOOOOO:.  :o::ooo.:ooOO.  ..:..:o.
   .:.....:oo:OO:ooooo:oOOOOoo.   o. :o:.oo.:. .:  :o.oo
   :Oooo:oo:  :O:oOo:::::ooo:.   .o.  :oo:O:   .:..ooOOo
   :8Oo:...  ..o:oo::::.....     o:..:oOO:...:.:::ooOOOo
     :OOoo:...:o::::.:o:.     ..::.:::o::  .:.::::..o8Oo.
       :oooo..:o:.:::::o:..........:o:...::..oOo::o::O8O:..
         .oo...OO:. ...:.    .. .:oOo:.  :o: .o::::. .oo..::
           .:.:O8:..:..::..   ...::oOo.   ::.... .:.....
             .ooOo:oo:.:o::::..               oOo::.:o.
                ...... .:ooOo.              . .O8OOOO:
                          .o:                 .o:.o:.
                                               .oo:
                                                 ..

Usage: $(Split-Path -Path $PSCommandPath -Leaf) [help] [bootstrap] [call]

personal development environment on windows platforms.

Available flags (choose one):

help       Print this help and exit.
bootstrap  run os setup then generic posix setup.
call `$NAME call a specific function by name. leave name blank for a list of functions.
"@ | Write-Host
}

function warn {
  Param(
    [string] $Message
  )

  Write-Host $Message -ForegroundColor Yellow
}

switch ($args[0]) {
  "help" { usage }
  "bootstrap" { bootstrap }
  "call" { call $args[1] }
  default { usage }
}
