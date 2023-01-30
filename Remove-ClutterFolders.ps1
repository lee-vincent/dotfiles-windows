
$ClutterFolders = @(
    "$HOME\3D Objects"
    "$HOME\Pictures"
    "$HOME\Contacts"
    "$HOME\Favorites"
    "$HOME\Links"
    "$HOME\Music"
    "$HOME\Saved Games"
    "$HOME\Videos"
    "$HOME\Searches"
    "$HOME\ansel"
    "$HOME\.ms-ad"
)

foreach ($Folder in $ClutterFolders) {
    if (Test-Path -Path $Folder) {
        Remove-Item -Path $Folder -Force -Recurse
    }
}
