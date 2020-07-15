function Get-RandomString {
	<#
		.SYNOPSIS
			Returns a random string of a given length.

		.DESCRIPTION
			Takes in a minimum and maximum lenth and then builds a string of that size.

		.PARAMETER LengthMin
			Integer for the minimum length of the string

		.PARAMETER LengthMax
			Integer for the maximum length of the string

		.NOTES
			Name: Get-RandomString
			Author: Jeff Bolduan
			LASTEDIT: 3/11/2016

		.EXAMPLE
			Get-RandomString -LengthMin 5 -LengthMax 10

			Will return a random string composed of [a-z][A-Z][0-9] and dash, underscore and period.  It's length will be between 5 and 10.
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$LengthMin,

		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[string]$LengthMax,

		[Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[string]$ValidCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_."
	)

	$PossibleCharacters = $ValidCharacters.ToCharArray()

	$Result = ""

	if($LengthMin -eq $LengthMax) {
		$Length = $LengthMin
	} else {
		$Length = Get-Random -Minimum $LengthMin -Maximum $LengthMax
	}

	#Write-Verbose -Message "Length: $Length"
	for($i = 0; $i -lt $Length; $i++) {
		$Result += $PossibleCharacters | Get-Random
	}

	return $Result
}
