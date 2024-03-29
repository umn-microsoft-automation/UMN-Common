﻿####### UMN-Common Module ####

###
# Copyright 2017 University of Minnesota, Office of Information Technology

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
###

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
} #END Convert-ColumnIndexToA1Notation

<#
    .Synopsis
    convert text or byte array to URL friendly BAse64
    .DESCRIPTION
    convert text or byte array to URL friendly BAse64
    .EXAMPLE
    ConvertTo-Base64URL -text $headerJSON
    .EXAMPLE
        ConvertTo-Base64URL -Bytes $rsa.SignData($toSign,"SHA256")
#>
function ConvertTo-Base64URL
{
    param
    (
        [Parameter(ParameterSetName='String')]
        [string]$text,

        [Parameter(ParameterSetName='Bytes')]
        [System.Byte[]]$Bytes
    )

    if($Bytes){$base = $Bytes}
    else{$base =  [System.Text.Encoding]::UTF8.GetBytes($text)}
    $base64Url = [System.Convert]::ToBase64String($base)
    $base64Url = $base64Url.Split('=')[0]
    $base64Url = $base64Url.Replace('+', '-')
    $base64Url = $base64Url.Replace('/', '_')
    $base64Url
}

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
} #END ConvertTo-OrderedDictionary

<#
    .Synopsis
    zip up module for DSC pull Server - can not use 7zip
    .DESCRIPTION
    zip up module for DSC pull Server - can not use 7zip
    .EXAMPLE
    CreateZipFromPSModulePath -ListModuleNames cChoco -Destination $dest
#>
function CreateZipFromPSModulePath
{
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
} #END Get-ARP

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
} #END Get-ExceptionsList

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
} #END Get-RandomString

#region Get-UsersIDM
	function Get-UsersIDM
	{
		<#
			.Synopsis
				Fetch list of users from IDM
			.DESCRIPTION
				Fetch list of users from IDM
			.PARAMETER ldapServer
				Name of LDAP server to connect to
			.PARAMETER ldapSearchString
				LDAP query to execute
			.PARAMETER searchDN
				DN to execute search against
			.PARAMETER TimeoutMinutes
				Timeout for the query, in minutes, defaults to 30. If the query exceeds this time it will throw an exception
			.EXAMPLE
				$users = Get-UsersIDM -ldapCredential $ldapCredential -ldapServer $ldapServer -ldapSearchString "(Role=*.cur*)" -TimeoutMinutes 60
			.EXAMPLE
				$users = Get-UsersIDM -ldapCredential $ldapCredential -ldapServer $ldapServer -ldapSearchString "(&(Role=*.staff.*)(cn=mrEd))"
		#>

		[CmdletBinding()]
		Param
		(
			[System.Net.NetworkCredential]$ldapCredential,

			[Parameter(Mandatory)]
			[string]$ldapServer,

			[Parameter(Mandatory)]
			[string]$ldapSearchString,

			[string]$searchDN,

			[int]$TimeoutMinutes = 30
		)
		#Load the assemblies needed for ldap lookups
		$null = [System.Reflection.Assembly]::LoadWithPartialName("System.DirectoryServices.Protocols")
		$null = [System.Reflection.Assembly]::LoadWithPartialName("System.Net")

		#setup the ldap connection
		$ldapConnection = New-Object System.DirectoryServices.Protocols.LdapConnection((New-Object System.DirectoryServices.Protocols.LdapDirectoryIdentifier($ldapServer,636)), $ldapCredential)
		$ldapConnection.AuthType = [System.DirectoryServices.Protocols.AuthType]::Basic
		$ldapConnection.SessionOptions.ProtocolVersion = 3
		#cert validation fails, so this will never validate the cert and just connect things
		$ldapConnection.SessionOptions.VerifyServerCertificate = { return $true; }
		$ldapConnection.SessionOptions.SecureSocketLayer = $true

		$ldapConnection.Bind()

		#build the ldap query
		$ldapSearch = New-Object System.DirectoryServices.Protocols.SearchRequest
		$ldapSearch.Filter = $ldapSearchString
		$ldapSearch.Scope = "Subtree"
		$ldapSearch.DistinguishedName = $searchDN

		#execute query for Students...default 30 minute timeout...generally takes about 12 minutes
		$ldapResponse = $ldapConnection.SendRequest($ldapSearch, (New-Object System.TimeSpan(0,$TimeoutMinutes,0))) -as [System.DirectoryServices.Protocols.SearchResponse]
		$null = $ldapConnection.Dispose()
		return ($ldapResponse)
	}
#endregion

#region Get-WebReqErrorDetails
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
#endregion
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
} #END Out-RecursiveHash

#region Send-SplunkHEC
	function Send-SplunkHEC
	{
		<#
			.Synopsis
				Send event to Splunk HTTP Event Collector
			.DESCRIPTION
				Send event to Splunk HTTP Event Collector
			.PARAMETER uri
				URI for HEC endpoint
			.PARAMETER header
				contains auth token
			.PARAMETER host
				Part of Splunk Metadata for event.  Device data being sent from
			.PARAMETER source
				Part of Splunk Metadata for event.  Source
			.PARAMETER sourceType
				Part of Splunk Metadata for event.  SourceType
			.PARAMETER Retries
				Set how many retries will be attempted if invoking fails
			.PARAMETER SecondsDelay
				Set how many seconds to wait between retries
			.PARAMETER metadata
				Part of Splunk Metadata for event.   Combination of host,source,sourcetype in performatted hashtable, will be comverted to JSON
			.PARAMETER eventData
				Event Data in hastable or pscustomeobject, will be comverted to JSON
			.PARAMETER JsonDepth
				Optional, specifies the Depth parameter to pass to ConvertTo-JSON, defaults to 100
		#>
		[CmdletBinding()]
		Param
		(
			# Param1 help description
			[Parameter(Mandatory)]
			[string]$uri,

			[Parameter(Mandatory)]
			[Collections.Hashtable]$header,

			[Parameter(Mandatory,ParameterSetName='Components')]
			[String]$source,

			[Parameter(Mandatory,ParameterSetName='Components')]
			[String]$sourceType,

			[Alias("Host")]
			[Parameter(Mandatory,ParameterSetName='Components')]
			[String]$EventHost,

			[Parameter(Mandatory,ParameterSetName='hashtable')]
			[Collections.Hashtable]$metadata,

			# This can be [Management.Automation.PSCustomObject] or [Collections.Hashtable]
			[Parameter(Mandatory)]
			$eventData,

			[int]$Retries = 5,

			[int]$SecondsDelay = 10,

			[int]$JsonDepth = 100
		)

		Begin{
			$retryCount = 0
			$completed = $false
			$response = $null
		}
		Process
		{
			if ($metadata){$bodySplunk = $metadata.Clone()}
			else {$bodySplunk = @{'host' = $EventHost;'source' = $source;'sourcetype' = $sourcetype}}
			#Splunk takes time in Unix Epoch format, so first get the current date,
			#convert it to UTC (what Epoch is based on) then format it to seconds since January 1 1970.
			#Without converting it to UTC the date would be offset by a number of hours equal to your timezone's offset from UTC
			$bodySplunk['time'] = (Get-Date).toUniversalTime() | Get-Date -UFormat %s
			$internalEventData = $eventData | ConvertTo-Json | ConvertFrom-Json
			Add-Member -InputObject $internalEventData -Name "SplunkHECRetry" -Value $retryCount -MemberType NoteProperty
			$bodySplunk['event'] = $internalEventData
		    while (-not $completed) {
				try {
					$response = Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing -Body ($bodySplunk | ConvertTo-Json -Depth $JsonDepth) -Method Post
					if ($response.text -ne 'Success' -or $response.code -ne 0){throw "Failed to submit to Splunk HEC $($response)"}
					$completed = $true
				}
				catch {
					if ($retrycount -ge $Retries) {
						throw
					}
					else {
						Start-Sleep $SecondsDelay
						$retrycount++
						$bodySplunk.event.SplunkHECRetry = $retryCount
					}
				}
			}
		}
		End{return $true}
	}
#endregion


#region Get-CurrentEpochTime
function Get-CurrentEpochTime
{
	<#
		.Synopsis
			Get current Epoch Time (seconds from 00:00:00 1 January 1970 UTC) as string with 1/100,000 of a second precision
		.DESCRIPTION
			Get current Epoch Time (seconds from 00:00:00 1 January 1970 UTC) as string with 1/100,000 of a second precision
	#>
	[OutputType([string])]
	[CmdletBinding()]
	Param
	(
	)

	Begin{}
	Process
	{
		(Get-Date).toUniversalTime() | Get-Date -UFormat %s
	}
	End{}
}
#endregion

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
} #END Test-RegistryValue

function Write-Log {
	<#
		.SYNOPSIS
		This function is used to pass messages to a ScriptLog.  It can also be leveraged for other purposes if more complex logging is required.

		.DESCRIPTION
		Write-Log function is setup to write to a log file in a format that can easily be read using CMTrace.exe. Variables are setup to adjust the output.

		.PARAMETER Message
		The message you want to pass to the log.

		.PARAMETER Path
		The full path to the script log that you want to write to.

		.PARAMETER Severity
		Manual indicator (highlighting) that the message being written to the log is of concern. 1 - No Concern (Default), 2 - Warning (yellow), 3 - Error (red).

		.PARAMETER Component
		Provide a non null string to explain what is being worked on.

		.PARAMETER Context
		Provide a non null string to explain why.

		.PARAMETER Thread
		Provide a optional thread number.

		.PARAMETER Source
		What was the root cause or action.

		.PARAMETER Console
		Adjusts whether output is also directed to the console window.

		.NOTES
		Name: Write-Log
		Author: Aaron Miller
		LASTEDIT: 01/23/2013 10:09:00

		.EXAMPLE
		Write-Log -Message $exceptionMsg -Path $ScriptLog -Severity 3
		Writes the content of $exceptionMsg to the file at $ScriptLog and marks it as an error highlighted in red
	#>

	PARAM(
		[Parameter(Mandatory=$true)][string]$Message,
		[Parameter(Mandatory=$false)][string]$Path = "$env:TEMP\CMTrace.Log",
		[Parameter(Mandatory=$false)][int]$Severity = 1,
		[Parameter(Mandatory=$false)][string]$Component = " ",
		[Parameter(Mandatory=$false)][string]$Context = " ",
		[Parameter(Mandatory=$false)][string]$Thread = "1",
		[Parameter(Mandatory=$false)][string]$Source = "",
		[Parameter(Mandatory=$false)][switch]$Console
	)

	# Setup the log message

		$time = Get-Date -Format "HH:mm:ss.fff"
		$date = Get-Date -Format "MM-dd-yyyy"
		$LogMsg = '<![LOG['+$Message+']LOG]!><time="'+$time+'+000" date="'+$date+'" component="'+$Component+'" context="'+$Context+'" type="'+$Severity+'" thread="'+$Thread+'" file="'+$Source+'">'

	# Write out the log file using the ComObject Scripting.FilesystemObject

		$ForAppending = 8
		$oFSO = New-Object -ComObject scripting.filesystemobject
		$oFile = $oFSO.OpenTextFile($Path, $ForAppending, $true)
		$oFile.WriteLine($LogMsg)
		$oFile.Close()
		Remove-Variable oFSO
		Remove-Variable oFile

	# Write to the console if $Console is set to True

		if ($Console -eq $true) {Write-Host $Message}

} #END Write-Log

function Get-RandomCharacter{
	<#
	.SYNOPSIS
	This function is to randomize a list of characters for password generation.

	.PARAMETER length
	How many of each character set you want.

	.PARAMETER characters
	A set list of characters to be selected from.

	.EXAMPLE
	Get-RandomCharacters -length 2 -characters '1234567890'
	42

	.NOTES
	Taken from all over the web. Notable = https://activedirectoryfaq.com/2017/08/creating-individual-random-passwords/
	#>

	param(
	[Parameter(Mandatory=$true)]$length,
	[Parameter(Mandatory=$true)]$characters
	)
	Begin{}
	Process{
		$random = 1..$length | ForEach-Object {Get-Random -Maximum $characters.length}
	}
	End{
		return $characters[$random] -join ''

	}
}

function Scramble-String{
	<#
		.SYNOPSIS
		This function takes a list of characters and randomizes them.

		.PARAMETER inputString
		A string of characters to scramble.

		.EXAMPLE
		Scramble-String -inputString '12345'
		51432

		.NOTES
		Taken from all over the web. Notable = https://activedirectoryfaq.com/2017/08/creating-individual-random-passwords/
	#>
	param(
	[Parameter(Mandatory=$true)]
	[string]$inputString
	)
	Begin{$characterArray = $inputString.ToCharArray()}
	Process{
		$scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length
		$outputString = $scrambledStringArray -join ''
	}
	End{return $outputString}
}

function New-Password{
	<#
		.SYNOPSIS
		This function just generates a password based on predetermined character list.

		.PARAMETER passwordLength
		The length of the password

		.PARAMETER special
		Boolean for ignoring special characters. Default is True

		.EXAMPLE
		New-Password -passwordLength 15
		42

		.NOTES
		Taken from all over the web. Notable = https://activedirectoryfaq.com/2017/08/creating-individual-random-passwords/
	#>
	param(
		[int]$passwordLength = 40,

		[boolean]$special = $True
	)
	Begin{
		[int]$length = [Math]::Truncate($passwordLength / 4)

		switch ($passwordLength % 4) {
			0 { $lengths = @($length, $length, $length, $length) }
			1 { $lengths = @($length, $length, $length, ($length + 1)) }
			2 { $lengths = @($length, $length, ($length + 1), ($length + 1)) }
			3 { $lengths = @($length, ($length + 1), ($length + 1), ($length + 1)) }
		}
	}
	Process{
		$password = Get-RandomCharacter -length $lengths[0] -characters 'abcdefghiklmnoprstuvwxyz'
		$password += Get-RandomCharacter -length $lengths[1] -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
		$password += Get-RandomCharacter -length $lengths[2] -characters '1234567890'
		If($special -eq $True){
			$password += Get-RandomCharacter -length $lengths[3] -characters '!$%&()=}][{#+'
		}
		Else{
			$password += Get-RandomCharacter -length $lengths[3] -characters '150AHKbrp2z3'
		}
		$password = Scramble-String $password
	}
	End{return $password}
}