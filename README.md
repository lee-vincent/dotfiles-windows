# Vinnie dotfiles for Windows WSL2 Ubuntu dev machine setup

A collection of PowerShell files for Windows, including common application installation through `Chocolatey`, and developer-minded Windows configuration defaults. 

## Installation

### Hyper-V Testing

When testing/iterating use Windows 10 Home 10.0.19042 Build 19042 Version 20H2 on a Hyper-V VM

Nested Virtualization must be enabled manually on the VM for WSL2 to install

```posh
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```

### Using Git and the bootstrap script

You can clone the repository wherever you want. (`~\repos\dotfiles-windows`) The bootstrapper script will copy the files to your PowerShell Profile folder.

From PowerShell:
```posh
git clone https://github.com/jayharris/dotfiles-windows.git; cd dotfiles-windows; . .\bootstrap.ps1
```

To update your settings, `cd` into your local `dotfiles-windows` repository within PowerShell and then:

```posh
. .\bootstrap.ps1
```

### My Preferred method: Git-free install

> Run PowerShell as Administrator to install dotfiles without Git. Note that this will automatically execute the windows.ps1 script and a restart

```posh
Set-ExecutionPolicy Unrestricted -Force; iex ((new-object net.webclient).DownloadString('https://raw.github.com/lee-vincent/dotfiles-windows/master/setup/install.ps1'))
```

To update later on, just run that command again.

### Add custom commands without creating a new fork

If `.\extra.ps1` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don't want to commit to a public repository.

`.\extra.ps1` could look something like this:

Extras is designed to augment the existing settings and configuration. You could also use `./extra.ps1` to override settings, functions and aliases, but it is probably better to fork.

### Sensible Windows defaults

When setting up a new Windows PC, you may want to set some Windows defaults and features, such as showing hidden files in Windows Explorer and removing stock programs. This will also set your machine name and full user name, so you may want to modify this file before executing. It will automatically restart the machine upon completion.

```posh
.\windows.ps1
```

If testing in a Hyper-V VM shut down the guest os and run the following from the host machine

```posh
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```

### Install dependencies and packages

When setting up a new Windows box, you may want to install some common packages, utilities, and dependencies. These could include node.js packages via [NPM](https://www.npmjs.org), [Chocolatey](http://chocolatey.org/) packages, Windows Features and Tools via [Web Platform Installer](https://www.microsoft.com/web/downloads/platform.aspx), and Visual Studio Extensions from the [Visual Studio Gallery](http://visualstudiogallery.msdn.microsoft.com/).

```posh
Set-Location ~\Documents\WindowsPowershell\
```

```posh
.\deps.ps1
```

> The scripts will install Chocolatey, Chrome, WSL2, and other dev tools.

> **Visual Studio Extensions**  
> Extensions will be installed into your most current version of Visual Studio. You can also install additional plugins at any time via `Install-VSExtension $url`. The Url can be found on the gallery; it's the extension's `Download` link url.



## Forking your own version

This repository is built around using a Windows 10 machine with WSL2 Ubuntu installed as a primary development enviornment. This repository is the Windows half of the dotfiles and configuration setup. This other repo has the WSL2 stuff.

If you fork for your own custom configuration, you will need to edit a few files to reference your own repository:

Within `/setup/install.ps1`, modify the Repository variables.
```posh
$account = "xxxxxxxxxxxx"
$repo    = "dotfiles-windows"
$branch  = "master"
```

Within the Windows Defaults file, `/windows.ps1`, modify the Machine
name on the first line.
```posh
(Get-WmiObject Win32_ComputerSystem).Rename("MyMachineName") | Out-Null
```

Finally, be sure to reference your own repository in the git-free installation command.
```posh
iex ((new-object net.webclient).DownloadString('https://raw.github.com/$account/$repo/$branch/setup/install.ps1'))
```