function Get-ARP {
	<#
		.SYNOPSIS
			This function is designed to return all ARP entries

		.DESCRIPTION
			This function returns an object containing all arp entries and details for each sub item property. On 64-bit
			powershell sessions there's dynamic paramters to specify the the 32-bit registry or 64-bit registry only

		.NOTES
			Name: Get-ARP
			Author: Aaron Miller
			LASTEDIT: 05/08/2013

		.EXAMPLE
			$ARP = Get-ARP
			This returns all arp entries into a variable for processing later.

	#>
	[CmdletBinding(DefaultParameterSetName='none')]
	Param ()

	DynamicParam {
		if ([IntPtr]::size -eq 8) {
			$att1 = new-object -Type System.Management.Automation.ParameterAttribute -Property @{ParameterSetName="x64ARP"}
			$attC1 = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
			$attC1.Add($att1)
			$dynParam1 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("x64ARP", [switch], $attC1)

			$att2 = new-object -Type System.Management.Automation.ParameterAttribute -Property @{ParameterSetName="x86ARP"}
			$attC2 = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
			$attC2.Add($att2)
			$dynParam2 = new-object -Type System.Management.Automation.RuntimeDefinedParameter("x86ARP", [switch], $attC2)

			$paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
			$paramDictionary.Add("x64ARP", $dynParam1)
			$paramDictionary.Add("x86ARP", $dynParam2)
			return $paramDictionary
		}
	}

	Begin {
		$Primary = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
		$Wow = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
		$toProcess = @()
		switch ($PsCmdlet.ParameterSetName) {
			"x64ARP" {$toProcess+=$Primary}
			"x86ARP" {$toProcess+=$Wow}
			default {$toProcess+=$Primary;if ([IntPtr]::size -eq 8) {$toProcess+=$Wow}}
		}
	}

	End {Return [array]($toProcess | ForEach-Object {Get-ChildItem $_} | ForEach-Object {Get-ItemProperty $_.pspath})}
}
