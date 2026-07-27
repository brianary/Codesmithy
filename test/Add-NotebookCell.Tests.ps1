<#
.SYNOPSIS
Tests running within a Polyglot Notebook, appending a cell to it.
#>

return #TODO: Probably retire the cmdlet entirely
if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
	$mockfile = Join-Path $PSScriptRoot mock ([io.path]::ChangeExtension((Split-Path $PSCommandPath -Leaf), 'cs'))
	try {[void][Kernel]}
	catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
}
Describe 'Add-NotebookCell' -Tag Add-NotebookCell {
	Context 'When run within a Polyglot Notebook, appends a cell to it' -Tag AddNoteboodCell,Add,NotebookCell,Notebook {
		It "Adding language '<Language>' code '<Code>' should happen" -TestCases @(
			@{ Language = 'sql'; Code = "select * from products;" }
			@{ Language = 'mermaid'; Code = "flowchart LR`nA -->B" }
		) {
			Param([string] $Language, [string] $Code)
			$Code |Add-NotebookCell -Language $Language
			[Kernel]::Root.Sent.Language |Should -BeExactly $Language
			[Kernel]::Root.Sent.Content.TrimEnd() |Should -BeExactly $Code
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
