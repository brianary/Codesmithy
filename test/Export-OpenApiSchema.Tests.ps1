<#
.SYNOPSIS
Tests extracting a JSON schema from an OpenAPI definition.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Export-OpenApiSchema' -Tag Export-OpenApiSchema {
	Context 'Extracts a JSON schema from an OpenAPI definition' -Tag ExportOpenApiSchema,Export,OpenApi {
		It "Exports the response schema from sample schema" {
			(Export-OpenApiSchema "$PSScriptRoot/data/sample-openapi.json") -replace '\r' |
				Should -BeExactly (@'
{
  "required": [
    "id",
    "name"
  ],
  "properties": {
    "id": {
      "type": "integer",
      "example": 4
    },
    "name": {
      "type": "string",
      "example": "Arthur Dent"
    }
  },
  "type": "object",
  "$schema": "http://json-schema.org/draft-04/schema#"
}
'@ -replace '\r')
		}
		It "Exports the request schema from sample schema" {
			(Export-OpenApiSchema "$PSScriptRoot/data/sample-openapi.json" -RequestSchema) -replace '\r' |
				Should -BeExactly (@'
{
  "type": "integer",
  "minimum": 1,
  "format": "int64",
  "$schema": "http://json-schema.org/draft-04/schema#"
}
'@ -replace '\r')
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
