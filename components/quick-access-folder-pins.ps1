Add-Type -TypeDefinition @'
using System.Management.Automation;
using System.Management.Automation.Runspaces;


public class QuickAccessFolderPinner
{
    public static void RemoveFolderFromQuickAccess(string pathToFolder)
    {
        using (var runspace = RunspaceFactory.CreateRunspace())
        {
            runspace.Open();
            var ps = PowerShell.Create();
            var removeScript = "((New-Object -ComObject shell.application).Namespace(\"shell:::{{679f85cb-0220-4080-b29b-5540cc05aab6}}\").Items() | Where-Object {{ $_.Path -EQ \"{pathToFolder}\" }}).InvokeVerb(\"unpinfromhome\")";
            ps.AddScript(removeScript);
            ps.Invoke();
        }
    }
}
'@