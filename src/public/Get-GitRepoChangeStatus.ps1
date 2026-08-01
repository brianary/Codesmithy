<#
.SYNOPSIS
Indicates whether there are outgoing changes in the local repo or incoming ones from the remote repo.

.INPUTS
System.IO.DirectoryInfo

.LINK
https://git-scm.com/docs

.EXAMPLE
Get-ChildItem ~/GitHub -Directory |Get-GitRepoChangeStatus |Format-Table

In Out Repository
-- --- ----------
   ↑   Codesmithy
   ↑   Databaseline
       SelectHtml
       SelectXmlExtensions
   ↑   Unicodery
↓  ↑   webcoder
#>

[CmdletBinding()] Param(
# The directory containing the local git repository.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][IO.DirectoryInfo] $Repository,
# Indicates that Emoji status characters should be returned.
[switch] $AsEmoji
)
Begin
{
    $Script:incoming,$Script:outgoing,$Script:notgit = $AsEmoji ? @('📥️','📤️','⛔') : @('↓','↑','-')
}
Process
{
	git -C $Repository.FullName rev-parse |Out-Null
	if(!$?)
	{
		return [pscustomobject]@{
			In         = $notgit
			Out        = $notgit
			Repository = $Repository.Name
		}
	}
    try
    {
        Push-Location $Repository.FullName
		git remote update *>&1 |Out-Null
        return [pscustomobject]@{
            In         = try{(git diff --name-only '@{u}') ? $outgoing : $null} catch {$_};
            Out        = try{(git status --porcelain) ? $incoming : $null} catch {$_};
            Repository = $Repository.Name
        }
    }
    finally {Pop-Location}
}
