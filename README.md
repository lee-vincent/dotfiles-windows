﻿## Vinnie's dotfiles for Windows 10 with WSL2 Ubuntu machine setup

A collection of PowerShell files for Windows, including common application installation through `Chocolatey`, and developer-minded Windows configuration defaults.


## Testing and Iterating on Hyper-V

To fine tune settings for your own use case, I recommend setting up a Windows VM for testing and iteration instead of using your workstation/laptop. Using a test VM is especially important when experimenting with and making adjustments to the Windows Registry.

This is the process I follow:

1. Create Windows 10 install media - currently a Windows.iso of Windows 10 Home 10.0.19042 Build 19042 Version 20H2
2. Boot the VM without connecting a network so you're able to create a "local" user account instead of being forced to connect a Microsoft account
3. After logging in as the local user the very first time, power the VM off
4. From PowerShell on your Hyper-V host, enable Nested Virtualization on the VM so you will be able to configure WSL2 inside the VM

From PowerShell:
```posh
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```
5. Boot the VM and log in as the local user
6. Take a Hyper-V snapshot/checkpoint of the VM so you can revert changes quickly. Name it something like "fresh-install"


## Installation

### Preferred method: Git-free install

> Run PowerShell as Administrator to install dotfiles without Git.
> The install.ps1 and bootstrap.ps1 scripts will be executed and
> overwrite identically named files in the following directories:
> ~\Documents\WindowsPowerShell
> ~\Documents\WindowsPowerShell\components
> ~\

```posh
Set-ExecutionPolicy Unrestricted -Force; iex ((new-object net.webclient).DownloadString('https://raw.github.com/lee-vincent/dotfiles-windows/master/setup/install.ps1'))
```

To update later on, just re-run that command.

### Using Git and the bootstrap script

You can clone the repository wherever you want. (`~\repos\dotfiles-windows`) The bootstrapper script will copy the files to your PowerShell Profile folder.

From PowerShell:
```posh
git clone https://github.com/lee-vincent/dotfiles-windows.git; cd dotfiles-windows; . .\bootstrap.ps1
```

To update your settings, `cd` into your local `dotfiles-windows` repository within PowerShell and then:

```posh
. .\bootstrap.ps1
```

### Add custom commands without creating a new fork

If `.\extra.ps1` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don't want to commit to a public repository.

`.\extra.ps1` could look something like this:

Extras is designed to augment the existing settings and configuration. You could also use `./extra.ps1` to override settings, functions and aliases, but it is probably better to fork.

### Sensible Windows defaults

When setting up a new Windows PC, you may want to set some Windows defaults and features, such as showing hidden files in Windows Explorer and removing stock programs. This will also set your machine name and full user name, so you may want to modify this file before executing. It will automatically restart the machine upon completion.

```posh
.\windows.ps1
```

If testing in a Hyper-V VM shut down the guest os and run the following from the host machine if you didn't follow the instructions in the "Testing and Iterating on Hyper-V" section

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