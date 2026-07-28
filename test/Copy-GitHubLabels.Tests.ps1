<#
.SYNOPSIS
Tests copying configured issue labels from one repo to another.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
	#TODO: Figure out PowerShellForGitHub dependency.
}
Describe 'Copy-GitHubLabels' -Tag Copy-GitHubLabels {
	BeforeEach {
		# see https://pester.dev/docs/usage/modules#-modulename
		Mock Get-GitHubLabel {
			$OwnerName |Should -BeExactly owner
			switch($RepositoryName)
			{
				SourceRepo {return @"
[{"name":"enhancement","color":"84b6eb","default":true,"description":"New functionality","LabelName":"enhancement"},
{"name":"duplicate","color":"cccccc","default":true,"description":"An issue that has already been reported.","LabelName":"duplicate"}]
"@ |ConvertFrom-Json}
				DestRepo {return @"
[{"name":"duplicate","color":"999999","default":true,"description":null,"LabelName":"duplicate"},
{"name":"bug","color":"fc2929","default":true,"description":null,"LabelName":"bug"}]
"@ |ConvertFrom-Json}
				default {throw "Unknown repository: $RepositoryName"}
			}
		} -ModuleName Codesmithy
		Mock New-GitHubLabel {} -ModuleName Codesmithy
		Mock Set-GitHubLabel {} -ModuleName Codesmithy
		Mock Remove-GitHubLabel {} -ModuleName Codesmithy
	}
	Context 'Copies configured issue labels from one repo to another' -Tag CopyGitHubLabels,Copy,GitHubLabels {
		It "Should add, update, and delete labels as needed by ReplaceAll mode" {
			Copy-GitHubLabels -OwnerName owner -RepositoryName SourceRepo -DestinationRepositoryName DestRepo -Mode ReplaceAll
			Should -Invoke -ModuleName Codesmithy -CommandName New-GitHubLabel -Times 1 -ParameterFilter {
				$OwnerName -eq 'owner' -and
				$RepositoryName -eq 'DestRepo' -and
				$Label -eq 'enhancement' -and
				$Color -eq '84b6eb' -and
				$Description -eq 'New functionality'
			}
			Should -Invoke -ModuleName Codesmithy -CommandName Set-GitHubLabel -Times 1 -ParameterFilter {
				$OwnerName -eq 'owner' -and
				$RepositoryName -eq 'DestRepo' -and
				$Label -eq 'duplicate' -and
				$Color -eq 'cccccc' -and
				$Description -eq 'An issue that has already been reported.'
			}
			Should -Invoke -ModuleName Codesmithy -CommandName Remove-GitHubLabel -Times 1 -ParameterFilter {
				$OwnerName -eq 'owner' -and
				$RepositoryName -eq 'DestRepo' -and
				$Label -eq 'bug'
			}
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
