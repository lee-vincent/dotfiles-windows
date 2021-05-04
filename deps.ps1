# Check to see if we are currently running "as Administrator"
if (!(Verify-Elevated)) {
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   $newProcess.Verb = "runas";
   [System.Diagnostics.Process]::Start($newProcess);

   exit
}



### Update Help for Modules
Write-Host "Updating Help..." -ForegroundColor "Yellow"
Update-Help -Force


### Package Providers
Write-Host "Installing Package Providers..." -ForegroundColor "Yellow"
Get-PackageProvider NuGet -Force | Out-Null
# Chocolatey Provider is not ready yet. Use normal Chocolatey
#Get-PackageProvider Chocolatey -Force
#Set-PackageSource -Name chocolatey -Trusted


### Install PowerShell Modules
Write-Host "Installing PowerShell Modules..." -ForegroundColor "Yellow"
Install-Module Posh-Git -Scope CurrentUser -Force
Install-Module PSWindowsUpdate -Scope CurrentUser -Force


### Chocolatey
Write-Host "Installing Desktop Utilities..." -ForegroundColor "Yellow"
if ((which cinst) -eq $null) {
    iex (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# system and cli
choco install curl                  --limit-output
choco install nuget.commandline     --limit-output
# choco install webpi               --limit-output
choco install git.install           --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
# choco install nvm.portable        --limit-output
# choco install python              --limit-output
# choco install ruby                --limit-output

# browsers
choco install GoogleChrome          --limit-output; <# pin; evergreen #> choco pin add --name GoogleChrome        --limit-output

# dev tools and frameworks
choco install wireshark             --limit-output
# choco install Fiddler             --limit-output
# choco install winmerge            --limit-output

Refresh-Environment
$MSIDwn="$home\Downloads\kernelupdate.msi"
$UbuntuDwn="$home\Downloads\ubuntu-2004.appx"
curl https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi --output $MSIDwn
Start-Process msiexec.exe -Wait -ArgumentList "/I $MSIDwn"
wsl --set-default-version 2
curl -L -o $UbuntuDwn https://aka.ms/wslubuntu2004
Add-AppxPackage $UbuntuDwn
ubuntu2004.exe