<#
.SYNOPSIS
Rename a git repository branch.

.FUNCTIONALITY
Git and GitHub

.LINK
https://docs.github.com/en/github/administering-a-repository/managing-branches-in-your-repository/renaming-a-branch#updating-a-local-clone-after-a-branch-name-changes

.LINK
https://github.com/github/renaming

.EXAMPLE
Rename-GitHubLocalBranch main

Rename the current branch to "main".
#>

[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
# The new branch name.
[Parameter(Position=0,Mandatory=$true)][string] $NewName
)

if(!$PSCmdlet.ShouldContinue('Have you renamed the branch in the GitHub UI?','GitHub Status'))
{
	Write-Information 'Rename the branch via the GitHub UI before running this script.'
	if((Get-Command gh -CommandType Application -ErrorAction Ignore)) {gh browse}
	Start-Process 'https://docs.github.com/en/github/administering-a-repository/managing-branches-in-your-repository/renaming-a-branch#renaming-a-branch'
	return
}

$oldName = git rev-parse --abbrev-ref HEAD
if(!$PSCmdlet.ShouldProcess("$oldName branch","rename to $NewName")) {return}

if(!(Get-Command git -Type Application -ErrorAction Ignore)) {throw "Git is required to be installed!"}
Write-Verbose "git branch -m $oldName $NewName"
git branch -m $oldName $NewName
Write-Verbose "git fetch origin"
git fetch origin
Write-Verbose "git branch -u origin/$NewName $NewName"
git branch -u "origin/$NewName" $NewName
Write-Verbose 'git remote set-head origin -a'
git remote set-head origin -a
Write-Verbose 'git remote prune origin'
git remote prune origin
