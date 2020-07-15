function Set-ModuleLatestVersion
{
	<#
		.Synopsis
		installs latest version of a module and deletes the old one
		.DESCRIPTION
		The problem with Update-module is it leave the old one behind, this cleans that up
		.EXAMPLE
		Set-ModuleLatestVersion -module xPSDesiredStateConfiguration
	#>
	[CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$module
    )

    Begin
    {
    }
    Process
    {
        $currentMod = get-module -ListAvailable $module
        if ($currentMod.count -gt 1){throw "Multiple version of module installed, clear out old $($currentMod.Version)"}
        $currentVersion = $currentMod.Version.ToString()
        Update-Module $module -Force
        if((get-module -ListAvailable $module).count -gt 1){Uninstall-Module -Name $module -RequiredVersion $currentVersion;get-module -ListAvailable $module}
        else {Write-Warning "Current version was latest version"}
    }
    End
    {
    }
}
