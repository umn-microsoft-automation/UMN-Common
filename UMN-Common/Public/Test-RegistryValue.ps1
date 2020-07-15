function Test-RegistryValue {
	<#
		.SYNOPSIS
			This function takes in a registry path, a name and then determines whether the registry value exists.

		.NOTES
			Name: Test-RegistryValue
			Author: Jeff Bolduan
			LASTEDIT: 09/01/2016

		.EXAMPLE
			Test-RegistryValue -Path HKLM:\Foo\Bar -Value FooBar
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string]$Path,

		[Parameter(Mandatory=$true)]
		[string]$Name,

		[Parameter(Mandatory=$false)]
		[switch]$PassThru
	)

	if(Test-Path -LiteralPath $Path) {
		$Key = Get-Item -LiteralPath $Path
		if($Key.GetValue($Value, $null) -ne $null) {
			if($PassThru) {
				Get-ItemProperty -LiteralPath $Path -Name $Name
			} else {
				$true
			}
		} else {
			$false
		}
	} else {
		return $false
	}
}
