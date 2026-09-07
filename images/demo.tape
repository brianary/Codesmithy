# VHS https://github.com/charmbracelet/vhs
Output demo.gif
Hide
Set Shell pwsh
Type "Install-PSResource -TrustRepository -RequiredResourceFile ../test/dependencies.psd1"
Enter
Type "Import-Module ../.publish/Codesmithy.psd1"
Enter
Type "Clear-Host"
Enter
Show
Type "Get-RepoName"
Enter
Sleep 2s
Type "Get-GitRepoChangeStatus ."
Enter
Sleep 4s
Type "git log (Get-GitFirstCommit)"
Enter
Sleep 3s
Type "Get-GitFileMetadata ../README.md"
Enter
Sleep 4s
Type "Find-DotNetTools microsoft.dotnet-interactive -Exact"
Enter
Sleep 3s
Type "$secret = ConvertTo-SecureString swordfish -AsPlainText -Force"
Enter
Type "New-Jwt -Subject 1234567890 -IssuedAt (Get-Date) -Secret $secret"
Enter
Sleep 3s
Type "Show-OpenApiInfo ../test/data/sample-openapi.json"
Enter
Sleep 9s
