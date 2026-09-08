<#
.SYNOPSIS
Indicates whether there are outgoing changes in the local repo or incoming ones from the remote repo.

.INPUTS
System.IO.DirectoryInfo

.LINK
https://git-scm.com/docs

.EXAMPLE
Get-ChildItem ~/GitHub -Directory |Get-GitRepoChangeStatus |Format-Table -AutoSize

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
[Parameter(Position=0,ValueFromPipeline=$true)][IO.DirectoryInfo] $Repository = '.',
# Indicates that Emoji status characters should be returned.
[switch] $AsEmoji
)
Begin
{
    $Script:incoming,$Script:outgoing,$Script:notgit = $AsEmoji ? @('📥️','📤️','⛔') : @('↓','↑','-')
}
Process
{
	if(!(Test-Path $Repository.FullName -Type Container)) {return}
	Push-Location $Repository.FullName
	[IO.DirectoryInfo] $root = git rev-parse --show-toplevel
	Pop-Location
	Push-Location $root.FullName
	$name = $root |Get-RepoName
	git -C $Repository.FullName rev-parse *>&1 |Out-Null
	if(!$?)
	{
		return [pscustomobject]@{
			In         = $notgit
			Out        = $notgit
			Repository = $name
		}
	}
    try
    {
		git remote update *>&1 |Out-Null
        return [pscustomobject]@{
            In         = try{(git diff --name-only '@{u}') ? $incoming : $null} catch {$_};
            Out        = try{(git status --porcelain) ? $outgoing : $null} catch {$_};
            Repository = $name
        }
    }
    finally {Pop-Location}
}
