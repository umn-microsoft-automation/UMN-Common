function Get-ExceptionsList {
	<#
		.SYNOPSIS
			Get's all exceptions available on current machine.

		.DESCRIPTION
			Goes through all the assemblies on the current computer and gets every exception then outputs them to the console.

		.NOTES
			Name: Get-ExceptionsList
			Author: Jeff Bolduan
			LASTEDIT: 3/11/2016
	#>
	[CmdletBinding()]
	param()

	# Get all current assemblies
	$CurrentDomainAssemblies = [appdomain]::CurrentDomain.GetAssemblies()

	# Loop through assemblies and output any members which contain exception in the name
	foreach($Assembly in $CurrentDomainAssemblies) {
		try {
			$Assembly.GetExportedTypes() | Where-Object {
				$_.Fullname -match 'Exception'
			}
		} catch {

		}
	}
}
