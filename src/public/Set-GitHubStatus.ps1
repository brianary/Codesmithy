<#
.SYNOPSIS
Updates your profile status on GitHub.
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Emoji,
[Parameter(Position=1,Mandatory=$true)][string] $Status
)
gh api graphql --raw-field "emoji=:$($Emoji.Trim(':')):" --raw-field "status=$Status" --raw-field @'
query=mutation UpdateStatus($emoji: String!, $status: String!) {
	changeUserStatus(input:{emoji: $emoji, message: $status}) {
	clientMutationId
	status {
			emoji
			message
			updatedAt
			user {
				login
			}
		}
	}
}
'@
