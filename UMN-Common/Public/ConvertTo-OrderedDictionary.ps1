function ConvertTo-OrderedDictionary {
	<#
		.SYNOPSIS
		Converts a hashtable or array to an ordered dictionary.

		.DESCRIPTION
		Takes in a hashtable or array and then returns an ordered dictionary.

		.PARAMETER Object
		Object to convert to an ordered dictionary

		.NOTES
		Name: ConvertTo-OrderedDictionary
		Author: Jeff Bolduan
		LASTEDIT: 3/11/2016

		.EXAMPLE
		@{"Item1" = "Value1"; "Item2" = "Value2"; "Item3" = "Value3"; "Item4" = "Value4"} | ConvertTo-OrderedDictionary

		Will return the following:
		Name						   Value
		----						   -----
		Item1						  Value1
		Item2						  Value2
		Item3						  Value3
		Item4						  Value4

		.EXAMPLE
		ConvertTo-OrderedDictionary -Object @{"Item1" = "Value1"; "Item2" = "Value2"; "Item3" = "Value3"; "Item4" = "Value4"}

		Will return the following:
		Name						  	Value
		----						  	-----
		Item1						  	Value1
		Item2						  	Value2
		Item3						 	Value3
		Item4						  	Value4
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
		[ValidateNotNullOrEmpty()]
		$Object
	)
	Begin {
		$Dictionary = [ordered]@{}
	}
    Process {
		if($Object -is [System.Collections.Hashtable]) {
			foreach($Key in ($Object.Keys | sort)) {
				$Dictionary.Add($Key, $Object[$Key])
			}
		} elseif($Object -is [System.Array]) {
			for($i = 0; $ -lt $Object.Count; $i++) {
				$Dictionary.Add($i, $Object[$i])
			}
		} else {
			throw [System.IO.InvalidDataException]
		}
	}
    End {
		return $Dictionary
	}
}
