<#
.SYNOPSIS
Adds config XDT connection strings to VSCode settings.

.FUNCTIONALITY
VSCode

.LINK
https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql

.LINK
http://code.visualstudio.com/

.LINK
https://git-scm.com/docs/git-rev-parse

.LINK
Add-VsCodeDatabaseConnection

.LINK
Get-ConfigConnectionStringBuilders

.EXAMPLE
Import-VsCodeDatabaseConnections

Adds any new (by name) connection strings found in XDT .config files into
the .vscode/settings.json mssql.connections collection for the mssql extension.
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','',
Justification='All configurations are returned as a collection.')]
[CmdletBinding()][OutputType([void])] Param()

function Get-ConfigConnections
{
	$connections = @()
	foreach($config in (Get-ChildItem -Recurse -Filter *.config |Select-Object -ExpandProperty FullName))
	{
		#TODO: Add or replace dependency.
		foreach($cs in (Get-ConfigConnectionStringBuilders.ps1 $config))
		{
			$name = $cs.Name + '.' + ($config |Split-Path -LeafBase |Split-Path -Extension).Trim('.')
			if($connections -and $name -in $connections.profileName){Write-Verbose "A '$name' connection already exists."; continue}
			#TODO: Add or replace dependency.
			Import-Variables.ps1 $cs.ConnectionString
			$vsconn = @{
				ProfileName = $name
				ServerInstance = ${Data Source}
				Database = ${Data Source}
			}
			if(!${Integrated Security}) {$vsconn += @{UserName=${User ID}}}
			Write-Verbose "Found '$($vsconn.ProfileName)' in $config"
			$connections += [pscustomobject]$vsconn
		}
	}
	Write-Verbose "Found $($connections.Count) connection strings."
	$connections
}

$connections = Get-ConfigConnections
if(!$connections){Write-Verbose 'Nothing to do.'}
else{$connections |Add-VsCodeDatabaseConnection}
