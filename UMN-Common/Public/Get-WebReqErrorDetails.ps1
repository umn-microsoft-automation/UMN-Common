function Get-WebReqErrorDetails {
	<#
		.SYNOPSIS
			Returns JSON Responsbody data from an Error thrown by Invoke-Webrequest or Invoke-RestMethod

		.DESCRIPTION
			Returns JSON Responsbody data from an Error thrown by Invoke-Webrequest or Invoke-RestMethod

		.PARAMETER err
			Error thrown by Invoke-Webrequest or Invoke-RestMethod

		.NOTES
			Author: Travis Sobeck
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[System.Management.Automation.ErrorRecord]$err
	)

	$reader = New-Object System.IO.StreamReader($err.Exception.Response.GetResponseStream())
	$reader.BaseStream.Position = 0
	$reader.DiscardBufferedData()
	return ($reader.ReadToEnd() | ConvertFrom-Json)
}
