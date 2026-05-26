<#
.SYNOPSIS
Returns the creation and last modification metadata for a file in a git repo.

.FUNCTIONALITY
Git and GitHub

.LINK
Get-ChildItem

.LINK
Resolve-Path

.EXAMPLE
Get-GitFileMetadata README.md

Path         : .\README.md
CreateCommit : 1fde7af
CreateAuthor : Brian Lalonde
CreateEmail  : brianary@example.com
CreateDate   : 01/19/2015 11:44:15
LastCommit   : dbe27ba
LastAuthor   : Brian Lalonde
LastEmail    : brianary@example.com
LastDate     : 12/07/2020 20:17:15
#>

[CmdletBinding()][OutputType([psobject])] Param(
# The path (or paths) to get metadata for.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[string[]] $Path,
# Recurse into subdirectories.
[switch] $Recurse
)
Begin
{
	if(!(Get-Command git -Type Application -ErrorAction Ignore)) {throw "Git is required to be installed!"}
}
Process
{
	foreach($f in Get-ChildItem $Path -Recurse:$Recurse)
	{
		$create_commit,$create_author,$create_email,$create_date =
			(git log --reverse --format="%h%x09%cn%x09%ae%x09%ai" $f |Select-Object -f 1) -split '\t'
		$last_commit,$last_author,$last_email,$last_date =
			(git log -1 --format="%h%x09%cn%x09%ae%x09%ai" $f |Select-Object -f 1) -split '\t'
		[pscustomobject]@{
			Path = Resolve-Path $f -Relative
			CreateCommit = $create_commit
			CreateAuthor = $create_author
			CreateEmail = $create_email
			CreateDate = [datetime]$create_date
			LastCommit = $last_commit
			LastAuthor = $last_author
			LastEmail = $last_email
			LastDate = [datetime]$last_date
		}
	}
}
