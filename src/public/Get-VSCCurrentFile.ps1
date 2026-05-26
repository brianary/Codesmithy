<#
.SYNOPSIS
Returns the path of the current file open in VSCode, when run in the PowerShell Extension Terminal in VSCode.

.OUTPUTS
System.String, System.Double, System.Int32, System.Boolean depending on VS Code JSON value type.

.FUNCTIONALITY
VSCode

.LINK
https://github.com/PowerShell/PowerShellEditorServices

.LINK
https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell

.EXAMPLE
Get-VSCCurrentFile

C:\GitHub\scripts\Get-VSCCurrentFile
#>

[CmdletBinding()][OutputType([string])] Param()
$psEditor.GetEditorContext().CurrentFile.Path
