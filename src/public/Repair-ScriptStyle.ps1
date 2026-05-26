<#
.SYNOPSIS
Accepts justifications for script analysis rule violations, fixing the rest using Invoke-ScriptAnalysis.

.FUNCTIONALITY
Scripts

.LINK
https://docs.microsoft.com/powershell/module/psscriptanalyzer/invoke-scriptanalyzer

.EXAMPLE
Repair-ScriptStyle .\MyScript.ps1

 PSAvoidUsingWriteHost in A:\Scripts\MyScript.ps1
 (!) Warning
 Lines: 19, 24, 25, 26, 27, 31, 32
 File 'MyScript.ps1' uses Write-Host. Avoid using Write-Host because it might not work in all hosts,
does not work when there is no host, and (prior to PS 5.0) cannot be suppressed, captured, or redirected.
Instead, use Write-Output, Write-Verbose, or Write-Information.

Confirm
Are you sure you want to perform this action?
Performing the operation "provide justification" on target "PSAvoidUsingWriteHost in A:\Scripts\MyScript.ps1".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost','',
Justification='This script is not intended for pipeline redirection. Also, it uses color.')]
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
# The path to a PowerShell script file to repair the style of.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path
)
Process
{
	$suppress = @()
	foreach($rule in Invoke-ScriptAnalyzer $Path |Group-Object RuleName)
	{
		$name = $rule.Name
		Write-Information " $name in $Path "
		foreach($severity in $rule.Group |Group-Object Severity)
		{
			switch($severity.Name)
			{
				Information {Write-Information ' 🆗 Information '}
				Warning {Write-Information ' ⚠️ Warning '}
				Error {Write-Information ' ❌ Error '}
				default {Write-Information " $($severity.Name) "}
			}
			foreach($message in $severity.Group |Group-Object Message)
			{
				Write-Information " Lines: $($message.Group.Line -join ', ')"
				Write-Information " $($message.Name)"
			}
		}
		if(!$PSCmdlet.ShouldProcess("$name in $Path",'provide justification')) {continue}
		$suppress += @"
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('$name','',
Justification='$((Read-Host 'Justification') -replace "'","''")')]

"@
	}
	if($suppress)
	{
		(Get-Content $Path -Raw) -replace '(?m)^(\[CmdletBinding\b)',"$suppress`$1" |
			ForEach-Object {$_.Trim()} |
			Out-File $Path utf8BOM
	}
	Invoke-ScriptAnalyzer $Path -Fix
}
