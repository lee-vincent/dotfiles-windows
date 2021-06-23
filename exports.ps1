# Make vscode the default editor
Set-Environment "EDITOR" "code.cmd"
Set-Environment "GIT_EDITOR" $Env:EDITOR

# Disable the Progress Bar
#$ProgressPreference='SilentlyContinue'
