$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"

# create C:\Users\Vinnie\Documents\WindowsPowerShell directory
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue

# create C:\Users\Vinnie\Documents\WindowsPowerShell\components directory
New-Item $componentDir -ItemType Directory -Force -ErrorAction SilentlyContinue


# Copy-Item overwrites existing files
Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./components/** -Destination $componentDir -Include **
Copy-Item -Path ./home/** -Destination $home -Include **

if(($null -eq $env:GIT_AUTHOR_NAME) -or ($null -eq $env:GIT_AUTHOR_EMAIL))
{
    $gitUserName = Read-Host -Prompt "Enter git username"
    $gitEmail = Read-Host -Prompt "Enter git email"

    [Environment]::SetEnvironmentVariable("GIT_AUTHOR_NAME", $gitUserName, "User")
    [Environment]::SetEnvironmentVariable("GIT_AUTHOR_EMAIL", $gitEmail, "User")

    Remove-Variable gitUserName
    Remove-Variable gitEmail
}

# this can only happen after the new .gitconfig is copied into $HOME
# needs to be here and in deps.ps1 because only bootstrap.ps1 gets run on a settings update
if((Get-Command git.exe -ErrorAction SilentlyContinue))
{
    Write-Host "running: git config --global user.name $env:GIT_AUTHOR_NAME" -ForegroundColor "Yellow"
    git config --global user.name $env:GIT_AUTHOR_NAME

    Write-Host "running: git config --global user.email $env:GIT_AUTHOR_EMAIL" -ForegroundColor "Yellow"
    git config --global user.email $env:GIT_AUTHOR_EMAIL
} else {
    Write-Host "can't find git.exe" -ForegroundColor "Yellow"
}

Remove-Variable componentDir
Remove-Variable profileDir
