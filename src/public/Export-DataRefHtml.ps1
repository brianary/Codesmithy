<#
.SYNOPSIS
Renders an XML schema or WSDL using Saxon into readable HTML.

.FUNCTIONALITY
XML

.INPUTS
System.String containing the path to an XML Schema or WSDL file.

.EXAMPLE
Show-DataRef DataModel.xsd

(Renders the XML schema as HTML.)
#>

[CmdletBinding()] Param(
# System.String containing the path to an XML Schema or WSDL file.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$SchemaFile
)
if(!(Get-Command SaxonHE12NetXslt -Type Application -EA Ignore))
{
	throw 'Saxon not found, install with: dotnet tool install -g SaxonHE12NetXslt'
}
$css  = Join-Path $PSScriptRoot 'dataref.css'
$xslt = Join-Path $PSScriptRoot 'dataref.xslt'
$html = [IO.Path]::ChangeExtension($SchemaFile,'html')
Copy-Item $css (Resolve-Path $SchemaFile |Split-Path) -vb
SaxonHE12NetXslt -s:$SchemaFile -xsl:$xslt -o:$html
