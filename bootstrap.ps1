$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"

# create C:\Users\Vinnie\Documents\WindowsPowerShell directory
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue

# create C:\Users\Vinnie\Documents\WindowsPowerShell\components directory
New-Item $componentDir -ItemType Directory -Force -ErrorAction SilentlyContinue


# Copy-Item overwrites existing files
Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./components/** -Destination $componentDir -Include **
Copy-Item -Path ./pink_powershell.ico -Destination $profileDir

# if this is the first install on a clean machine the symlinks should not yet exists
# advise user
if((Get-Item "$HOME\.gitconfig" -ErrorAction SilentlyContinue | Select-Object LinkType).LinkType -ne "SymbolicLink")
{
    write-host "No Symlink found for $HOME\.gitconfig make sure you runs deps.ps1 or set manually"
}

$gitUserName=""
$gitEmail=""
if(($null -eq $env:GIT_AUTHOR_NAME) -or ($null -eq $env:GIT_AUTHOR_EMAIL))
{
    $gitUserName = Read-Host -Prompt "Enter git username"
    $gitEmail = Read-Host -Prompt "Enter git email"

    [Environment]::SetEnvironmentVariable("GIT_AUTHOR_NAME", $gitUserName, "User")
    [Environment]::SetEnvironmentVariable("GIT_AUTHOR_EMAIL", $gitEmail, "User")


} else {
    $gitUserName = $env:GIT_AUTHOR_NAME
    $gitEmail = $env:GIT_AUTHOR_EMAIL
}

Remove-Variable gitUserName
Remove-Variable gitEmail
Remove-Variable componentDir
Remove-Variable profileDir
