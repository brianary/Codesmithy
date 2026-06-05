<#
.SYNOPSIS
Tests searching for matching dotnet tools.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Find-DotNetTools' -Tag Find-DotNetTools {
	Context 'Returns a list of matching dotnet tools' -Tag FindDotNetTools,Find,DotNetTools,DotNet {
		It "Finds .NET Interactive" {
			Find-DotNetTools microsoft.dotnet-interactive |
				Select-Object -First 1 -ExpandProperty PackageName |
				Should -BeExactly microsoft.dotnet-interactive
		}
		It "Finds Microsoft packages" {
			@(Find-DotNetTools microsoft).Count |Should -BeGreaterThan 0
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
