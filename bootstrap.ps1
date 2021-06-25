$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"

# create C:\Users\Vinnie\Documents\WindowsPowerShell directory
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue

# create C:\Users\Vinnie\Documents\WindowsPowerShell\components directory
New-Item $componentDir -ItemType Directory -Force -ErrorAction SilentlyContinue

Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./components/** -Destination $componentDir -Include **
Copy-Item -Path ./home/** -Destination $home -Include **
# New-Item -ItemType HardLink -Path "C:\Users\Vinnie\.gitconfig" -Target "C:\Users\Vinnie\repos\dotfiles-windows\home\.gitconfig"
Remove-Variable componentDir
Remove-Variable profileDir
