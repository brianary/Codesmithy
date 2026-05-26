<#
.SYNOPSIS
Gets the name of the repo.

.INPUTS
Objects with System.String Path or FullName properties.

.OUTPUTS
System.String of the repo name (the final segment of the first remote location).

.FUNCTIONALITY
Git and GitHub

.EXAMPLE
Get-RepoName

MyRepository
#>

[CmdletBinding()][OutputType([string])] Param(
# The path to the git repo to get the name for.
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path = $PWD.Path
)
Begin
{
	if(!(Get-Command git -Type Application -ErrorAction Ignore)) {throw "Git is required to be installed!"}
}
Process
{
    if(!(Test-Path $Path -Type Container)) {throw "The path $Path was not found."}
    try
    {
        Push-Location $Path
        git status |Out-Null
        if(!$?) {throw "The path $Path is not a git repo."}
        $remote = git remote |Select-Object -First 1
        if($remote) {return ([uri](git remote get-url $remote)).Segments[-1] -replace '\.git\z',''}
        else {return Split-Path $Path -Leaf}
    }
    finally {Pop-Location}
}
