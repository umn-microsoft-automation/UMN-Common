function Out-RecursiveHash {
	<#
		.SYNOPSIS
		Outputs a hashtable recursively

		.DESCRIPTION
		Takes in a hashtable and then writes the values stored within to output.

		.PARAMETER hash
		Hashtable to be outputted recursively

		.NOTES
		Name: Out-RecursiveHash
		Author: Jeff Bolduan
		LASTEDIT: 3/11/2016

		.EXAMPLE
		$hashtable = @{ "Item1" = @{ "SubItem1" = "Value" }; "Item2" = "Value2" }
		Out-RecursiveHash -Hash $hashtable

		This will output:
			SubItem1 : Value
			Item2 : Value2
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[hashtable]$Hash
	)
	$Return = ""

	# Loop through each of the hashtable keys and output the key pair unless it's a hashtable then recursive call
	foreach($key in $hash.keys) {
		if($hash[$key] -is [HashTable]) {
			$Return += (Out-RecursiveHash $hash[$key])
		} else {
			$Return += "$key : $($hash[$key])`n"
		}
	}

	return $Return
}
