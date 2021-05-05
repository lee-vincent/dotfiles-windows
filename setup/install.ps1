$account = "lee-vincent"
$repo    = "dotfiles-windows"
$branch  = "master"


$customLayout = "$home\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"
Write-Output '<?xml version="1.0"?>' > $customLayout
Write-Output '<LayoutModificationTemplate xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" Version="1" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout">' >> $customLayout
Write-Output '  <LayoutOptions StartTileGroupCellWidth="6"/>' >> $customLayout
Write-Output '  <DefaultLayoutOverride>' >> $customLayout
Write-Output '      <StartLayoutCollection>' >> $customLayout
Write-Output '          <defaultlayout:StartLayout GroupCellWidth="6"/>' >> $customLayout
Write-Output '      </StartLayoutCollection>' >> $customLayout
Write-Output '  </DefaultLayoutOverride>' >> $customLayout
Write-Output '</LayoutModificationTemplate>' >> $customLayout

Exit

$localRepoDir = Join-Path $HOME "repos"
if (![System.IO.Directory]::Exists($localRepoDir)) {[System.IO.Directory]::CreateDirectory($localRepoDir)}

$dotfilesTempDir = Join-Path $env:TEMP "dotfiles"
if (![System.IO.Directory]::Exists($dotfilesTempDir)) {[System.IO.Directory]::CreateDirectory($dotfilesTempDir)}
$sourceFile = Join-Path $dotfilesTempDir "dotfiles.zip"
$dotfilesInstallDir = Join-Path $dotfilesTempDir "$repo-$branch"


function Get-Webfile {
  param (
    [string]$url,
    [string]$file
  )
  Write-Host "Downloading $url to $file"
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -Uri $url -OutFile $file

}

function Expand-Zipfile {
    param (
        [string]$File,
        [string]$Destination = (Get-Location).Path
    )

    $filePath = Resolve-Path $File
    $destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

    If (($PSVersionTable.PSVersion.Major -ge 3) -and
        (
            [version](Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -ge [version]"4.5" -or
            [version](Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -ge [version]"4.5"
        )) {
        try {
            [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    } else {
        try {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
        } catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }
    }
}

Get-Webfile "https://github.com/$account/$repo/archive/$branch.zip" $sourceFile
if ([System.IO.Directory]::Exists($dotfilesInstallDir)) {[System.IO.Directory]::Delete($dotfilesInstallDir, $true)}
Expand-Zipfile $sourceFile $dotfilesTempDir

Push-Location $dotfilesInstallDir
& .\bootstrap.ps1
Pop-Location


$newpath= Split-Path -parent $profile
$newProcessArgs="-nologo", "-file .\windows.ps1"
Start-Process powershell.exe -WorkingDirectory $newpath -ArgumentList $newProcessArgs
exit
