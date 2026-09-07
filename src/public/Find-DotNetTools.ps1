<#
.SYNOPSIS
Returns a list of matching dotnet tools.

.FUNCTIONALITY
DotNet

.EXAMPLE
Find-DotNetTools interactive |Format-Table -AutoSize

PackageName                  Version     Authors                Downloads Verified
-----------                  -------     -------                --------- --------
microsoft.dotnet-interactive 1.0.516401  Microsoft              33682741      True
dotnet-repl                  0.1.216     jonsequitur            117599       False
#>

[CmdletBinding()] Param(
# The name of the tool to search for.
[Parameter(Position=0,Mandatory=$true)][string] $Name,
# Requires an exact package match.
[switch] $Exact
)

if(!(Get-Command dotnet -Type Application -ErrorAction Ignore))
{
	throw 'The dotnet CLI was not found.'
}
foreach($line in dotnet tool search $Name |Where-Object {$_ -match '^\S+\s+\d+(?:\.\d+)+\b'})
{
	$package,$version,$authors,$downloads,$verified = $line -split '\s\s+',5
	if($Exact -and ($package -ne $Name)) {continue}
	[pscustomobject]@{
		PackageName = $package
		Version     = try{[semver]$version}catch{try{[version]$version}catch{$version}};
		Authors     = $authors
		Downloads   = [long]$downloads
		Verified    = $verified.Trim() -eq 'x'
	}
}
