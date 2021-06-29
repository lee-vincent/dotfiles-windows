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
Copy-Item -Path ./pink_powershell.ico -Destination $profileDir


if (!(Test-Path "$HOME/AppData/Roaming/Code/User/")) {New-Item -Path "$HOME/AppData/Roaming/Code/User/" -Type Directory}
Copy-Item -Path ./vscode/** -Destination "$HOME/AppData/Roaming/Code/User/"

if (!(Test-Path "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\")) {New-Item -Path "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\" -Type Directory}
Copy-Item -Path ./WindowsTerminal/** -Destination "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"




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


# this can only happen after the new .gitconfig is copied into $HOME
# needs to be here and in deps.ps1 because only bootstrap.ps1 gets run on a settings update
# using $gitEmail and gitUserName so i dont have to refresh env vars?
if((Get-Command git.exe -ErrorAction SilentlyContinue))
{
    Write-Host "running: git config --global user.name $gitUserName" -ForegroundColor "Yellow"
    git config --global user.name $gitUserName

    Write-Host "running: git config --global user.email $gitEmail" -ForegroundColor "Yellow"
    git config --global user.email $gitEmail
} else {
    Write-Host "can't find git.exe" -ForegroundColor "Yellow"
    $gc = Get-Content $HOME\.gitconfig
    $notfound = 1
    $gc | ForEach-Object {
        if($_ -eq '[user]') {
            $notfound = 0
        }
    }
    if($notfound) {
        "[user]" | out-file -filepath $HOME\.gitconfig -Append -Encoding utf8
        "`tname = $gitUserName" | out-file -filepath $HOME\.gitconfig -Append -Encoding utf8
        "`temail = $gitEmail" | out-file -filepath $HOME\.gitconfig -Append -Encoding utf8
    }

}


Remove-Variable gitUserName
Remove-Variable gitEmail
Remove-Variable componentDir
Remove-Variable profileDir
