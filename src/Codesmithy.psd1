# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'Codesmithy.psm1'
ModuleVersion = '0.0.0.0' # placeholder to be overridden
CompatiblePSEditions = @('Core')
GUID = '8f8fd660-3d80-407f-bc66-c6f7c8e46fcd'
Author = 'Brian Lalonde'
CompanyName = 'Unknown'
Copyright = 'Copyright © 2026 Brian Lalonde'
Description = 'Utilities for .NET programmers.'
PowerShellVersion = '7.0'
# RequiredModules = ,'Microsoft.PowerShell.Utility'
FunctionsToExport = @('*') # '*'
CmdletsToExport = @() # '*'
VariablesToExport = @() # '*'
# AliasesToExport = @()
FileList = @('Codesmithy.psd1','Codesmithy.psm1')
PrivateData = @{
	PSData = @{
		Tags = @('Programming','.NET','DotNet','Code','Git','API','Schema')
		LicenseUri = 'https://github.com/brianary/Codesmithy/blob/master/LICENSE'
		ProjectUri = 'https://github.com/brianary/Codesmithy/'
		IconUri = 'http://webcoder.info/images/Codesmithy.svg'
		# ReleaseNotes = ''
		# PS7: A list of external modules that this module is dependent upon.
		# ExternalModuleDependencies = ,'Microsoft.PowerShell.Utility'
	}
}
}
