<#
.SYNOPSIS
Gets the SHA-1 hash of the first commit of the current repo.

.OUTPUTS
System.String containing the SHA-1 hash of this repo's first commit.

.FUNCTIONALITY
Git and GitHub

.EXAMPLE
Get-GitFirstCommit

1fde7af20e8560c720d42227495e8d15459aafa4
#>

[CmdletBinding()][OutputType([string])] Param()
if(!(Get-Command git -Type Application -ErrorAction Ignore)) {throw "Git is required to be installed!"}
git log --max-parents=0 --format=format:%H HEAD
