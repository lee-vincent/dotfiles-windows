$myIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myPrincipal=new-object System.Security.Principal.WindowsPrincipal($myIdentity)

if (!($myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))) {
    C:\Windows\System32\schtasks.exe /RUN /TN "PowerShellRunAsAdmin\PowerShellRunAsAdminTask"
    stop-process -Id $PID
}