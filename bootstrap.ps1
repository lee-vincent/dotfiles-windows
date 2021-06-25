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



if((Get-Command git.exe) -And (!($null -eq $env:GIT_AUTHOR_NAME)) -And (!($null -eq $env:GIT_AUTHOR_EMAIL)))
{
    Write-Host "running: git config --global user.name $env:GIT_AUTHOR_NAME" -ForegroundColor "Yellow"
    git config --global user.name $env:GIT_AUTHOR_NAME

    Write-Host "running: git config --global user.email $env:GIT_AUTHOR_EMAIL" -ForegroundColor "Yellow"
    git config --global user.email $env:GIT_AUTHOR_EMAIL
}

Remove-Variable componentDir
Remove-Variable profileDir
