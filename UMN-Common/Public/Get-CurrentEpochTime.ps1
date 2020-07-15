function Get-CurrentEpochTime
{
	<#
		.Synopsis
			Get current Epoch Time (seconds from 00:00:00 1 January 1970 UTC) as string with 1/100,000 of a second precision
		.DESCRIPTION
			Get current Epoch Time (seconds from 00:00:00 1 January 1970 UTC) as string with 1/100,000 of a second precision
	#>
	[OutputType([string])]
	[CmdletBinding()]
	Param
	(
	)

	Begin{}
	Process
	{
		(Get-Date).toUniversalTime() | Get-Date -UFormat %s
	}
	End{}
}
