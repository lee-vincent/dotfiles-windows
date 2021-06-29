# Check to see if we are currently running "as Administrator"
if (!(Assert-Elevated)) {
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
if ($null -eq (which cinst)) {
    Invoke-Expression (new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# system and cli
choco install curl                  --limit-output
choco install nuget.commandline     --limit-output
choco install git.install           --limit-output -params '"/GitAndUnixToolsOnPath /NoShellIntegration"'
choco install python              --limit-output


#choco install 7zip --limit-output
choco install cascadiacode --limit-output
# browsers
#choco install GoogleChrome          --limit-output

# dev tools and frameworks
#choco install wireshark             --limit-output
choco install vscode                --limit-output
#choco install visualstudio2019professional  --limit-output
choco install docker-desktop    --limit-output
#choco install putty                 --limit-output
# choco install adobereader /DesktopIcon /NoUpdates  --limit-output
choco install microsoft-windows-terminal --limit-output

Refresh-Environment


$VSCodeExtensions = @(
    "CoenraadS.bracket-pair-colorizer-2"
    "hashicorp.terraform"
    "ms-azuretools.vscode-docker"
    "ms-dotnettools.csharp"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    "ms-python.pythonms-toolsai.jupyter"
    "ms-vscode-remote.remote-containers"
    "ms-vscode-remote.remote-ssh"
    "ms-vscode-remote.remote-ssh-edit"
    "ms-vscode-remote.remote-wsl"
    "ms-vscode-remote.vscode-remote-extensionpack"
    "ms-vscode.cpptools"
    "ms-vscode.powershell"
    "redhat.vscode-yaml"
    "whizkydee.material-palenight-theme"

    # "GitHub.github-vscode-theme"
)



foreach ($Extension in $VSCodeExtensions) {   
    code --install-extension $Extension
}

# Fix a compatibility issue between vscode powershell integration and PackageManagement
powershell.exe -NoLogo -NoProfile -Command '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Install-Module -Name PackageManagement -Force -MinimumVersion 1.4.6 -Scope CurrentUser -AllowClobber -Repository PSGallery'

$MSIDwn="$home\Downloads\kernelupdate.msi"
$UbuntuDwn="$home\Downloads\ubuntu-2004.appx"


curl https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi --output $MSIDwn
Start-Process msiexec.exe -Wait -ArgumentList "/I $MSIDwn"
wsl --set-default-version 2

curl -L -o $UbuntuDwn https://aka.ms/wslubuntu2004
Add-AppxPackage $UbuntuDwn
ubuntu2004.exe

