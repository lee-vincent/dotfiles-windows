# These components will be loaded for all PowerShell instances

Push-Location (Join-Path (Split-Path -parent $profile) "components")

# From within the ./components directory...
. .\quick-access-folder-pins.ps1
. .\coreaudio.ps1
. .\git.ps1

Pop-Location
