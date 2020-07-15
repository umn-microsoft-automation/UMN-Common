function CreateZipFromPSModulePath
{
    <#
    .Synopsis
    zip up module for DSC pull Server - can not use 7zip
    .DESCRIPTION
    zip up module for DSC pull Server - can not use 7zip
    .EXAMPLE
    CreateZipFromPSModulePath -ListModuleNames cChoco -Destination $dest
    #>
    param(

        [Parameter(Mandatory)]
        [string[]]$ListModuleNames,

        [Parameter(Mandatory)]
        [string]$Destination
    )

    foreach ($module in $ListModuleNames)
    {
        $allVersions = Get-Module -Name $module -ListAvailable -Verbose
        # Package all versions of the module
        foreach ($moduleVersion in $allVersions)
        {
            $name   = $moduleVersion.Name
            $source = "$Destination\$name"
            # Create package zip
            $path    = $moduleVersion.ModuleBase
            $version = $moduleVersion.Version.ToString()
            Compress-Archive -Path "$path\*" -DestinationPath "$source.zip" -Verbose -Force
            $newName = "$Destination\$name" + "_" + "$version" + ".zip"
            # Rename the module folder to contain the version info.
            if (Test-Path $newName)
            {
                Remove-Item $newName -Recurse -Force
            }
            Rename-Item -Path "$source.zip" -NewName $newName -Force
        }
    }

}
