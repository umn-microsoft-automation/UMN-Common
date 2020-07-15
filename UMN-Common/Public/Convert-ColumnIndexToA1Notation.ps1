function Convert-ColumnIndexToA1Notation {
	<#
	.SYNOPSIS
		Short description
	.DESCRIPTION
		Long description
	.EXAMPLE
		Example
	.NOTES
		General notes
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[int]$ColumnIndex
	)
	process {
		while ($ColumnIndex -gt 0) {
			$Temp = ($ColumnIndex -1) % 26
			#$Letter =
		}
	}
}
