<#
.SYNOPSIS
Returns the TODOs for the current git repo, which can help document technical debt.

.EXAMPLE
Get-Todos |Out-GridView -Title "$((Get-Item $(git rev-parse --show-toplevel)).Name) TODOs"

Shows TODOs in this repo.
#>

[CmdletBinding()] Param()
Push-Location $(git rev-parse --show-toplevel)
Get-ChildItem -File -Recurse |
	Select-String -Pattern '\bTODO\b' -CaseSensitive |
	ForEach-Object {
		[string[]] $blame = git blame -p -L "$($_.LineNumber),$($_.LineNumber)" -- $_.Path
		$author = $blame |Select-String '^author (?<Author>.*)$' |
			ModernConveniences\Select-CapturesFromMatches -ValuesOnly
		$Time = $blame |Select-String '^author-time (?<Time>.*)$' |
			ModernConveniences\Select-CapturesFromMatches -ValuesOnly |
			ModernConveniences\ConvertFrom-EpochTime
		[pscustomobject]@{
			Author = $author
			Time = $time
			Todo = ($_.Line -split 'TODO:?\s*',2)[1].Trim()
			Path = Resolve-Path $_.Path -Relative
			LineNumber = $_.LineNumber
		}
	} |
	Sort-Object Time -Descending
Pop-Location
