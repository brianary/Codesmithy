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
#TODO: Add or replace dependency.
if(Test-Variable.ps1 psEditor) {Push-Location $psEditor.Workspace.Path}
else {throw 'Missing psEditor object'}
