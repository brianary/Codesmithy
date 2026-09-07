<#
.SYNOPSIS
Pushes the current VS Code editor workspace location to the location stack.

.FUNCTIONALITY
VSCode

.LINK
Push-Location

.EXAMPLE
Push-WorkspaceLocation

Pushes the current directory onto the stack, and changes to the workspace directory.
#>

[CmdletBinding()][OutputType([void])] Param()
if(ModernConveniences\Test-Variable psEditor) {Push-Location $psEditor.Workspace.Path}
else {throw 'Missing psEditor object'}

