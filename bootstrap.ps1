$profileDir = Split-Path -parent $profile
$componentDir = Join-Path $profileDir "components"

# create C:\Users\Vinnie\Documents\WindowsPowerShell directory
New-Item $profileDir -ItemType Directory -Force -ErrorAction SilentlyContinue

# create C:\Users\Vinnie\Documents\WindowsPowerShell\components directory
New-Item $componentDir -ItemType Directory -Force -ErrorAction SilentlyContinue


# Copy-Item overwrites existing files
Copy-Item -Path ./*.ps1 -Destination $profileDir -Exclude "bootstrap.ps1"
Copy-Item -Path ./components/** -Destination $componentDir -Include **

# if this is the first install on a clean machine the symlinks should not yet exists
# advise user
if((Get-Item "$HOME\.gitconfig" -ErrorAction SilentlyContinue | Select-Object LinkType).LinkType -ne "SymbolicLink")
{
    write-host "No Symlink found for $HOME\.gitconfig make sure you run deps.ps1 or set manually"
}

$gitUserName=""
$gitEmail=""
if(($null -eq $env:GIT_AUTHOR_NAME) -or ($null -eq $env:GIT_AUTHOR_EMAIL))
{
    $gitUserName = Read-Host -Prompt "Enter git username"
    $gitEmail = Read-Host -Prompt "Enter git email"

    [Environment]::SetEnvironmentVariable("GIT_AUTHOR_NAME", $gitUserName, "User")
    [Environment]::SetEnvironmentVariable("GIT_AUTHOR_EMAIL", $gitEmail, "User")
}

Remove-Variable gitUserName
Remove-Variable gitEmail
Remove-Variable componentDir
Remove-Variable profileDir

# <Replace the windows powershell path template>
# Define the path to the XML file
$xmlTemplateFilePath = ".\components\Remove-ClutterFolders.template"
$xmlFinalFilePath = ".\components\Remove-ClutterFolders.xml"

# Check if the XML file exists
if (Test-Path $xmlTemplateFilePath) {
    # Define the replacement value with single backslashes
    $userProfilePath = "$($env:USERPROFILE)\Documents\WindowsPowerShell"

    # Read the content of the XML file
    $xmlContent = Get-Content -Path $xmlTemplateFilePath -Raw

    # Replace the placeholder with the actual value
    $updatedContent = $xmlContent -replace "{{USER_POWERSHELL_PROFILE_PATH}}", $userProfilePath

    # Save the updated content back to the XML file
    Set-Content -Path "$xmlFinalFilePath" -Value $updatedContent -Encoding UTF8

    Write-Host "Updated the XML file successfully."
}
else {
    Write-Error "The XML file '$xmlTemplateFilePath' does not exist."
}
