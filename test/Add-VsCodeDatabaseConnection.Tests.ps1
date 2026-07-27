<#
.SYNOPSIS
Tests adding a VS Code MSSQL database connection to the repo.
#>

return #TODO: Re-enable
if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
	if(!(git config --global user.email)) {git config --global user.email "test@example.com"}
	if(!(git config --global user.name)) {git config --global user.name "Test User"}
}
Describe 'Add-VsCodeDatabaseConnection' -Tag Add-VsCodeDatabaseConnection {
	BeforeEach {
		Push-Location (mkdir ( $IsWindows ? "TestDrive:\$(New-Guid)" : "/var/tmp/$(New-Guid)" ))
		git init |Write-Information -infa Continue
	}
	AfterEach {
		if((Get-PSDrive TestDrive -EA Ignore) -and ("$PWD" -match "\A$([regex]::Escape($TestDrive))")) {Pop-Location}
		elseif("$PWD" -match "\A/var/tmp/") {Pop-Location}
	}
	Context 'Adds a VS Code MSSQL database connection to the repo.' `
		-Skip:(!!(Get-Variable psEditor -EA Ignore)) `
		-Tag AddVsCodeDatabaseConnection,Add,VsCodeDatabaseConnection {
		It 'Should add a trusted connection' -TestCases @(
			@{ ProfileName = 'ConnectionName'; ServerInstance = 'ServerName\instance'; Database = 'Database' }
			@{ ProfileName = 'AdventureWorks' ; ServerInstance = '(localdb)\ProjectsV13'; Database = 'AdventureWorks2016' }
		 ) {
			Param([string] $ProfileName, [string] $ServerInstance, [string] $Database)
			Join-Path .vscode settings.json |Should -Not -Exist -Because 'no settings should exist yet'
			Add-VsCodeDatabaseConnection -ProfileName $ProfileName `
				-ServerInstance $ServerInstance -Database $Database
			Join-Path .vscode settings.json |Should -Exist -Because 'VSCode settings should now exist'
			$conn = (Get-Content .vscode/settings.json |ConvertFrom-Json).'mssql.connections'
			$conn.authenticationType |Should -BeExactly Integrated `
				-Because 'without credentials, create a trusted/integrated connection'
			$conn.profileName |Should -BeExactly $ProfileName
			$conn.server |Should -BeExactly $ServerInstance
			$conn.database |Should -BeExactly $Database
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
