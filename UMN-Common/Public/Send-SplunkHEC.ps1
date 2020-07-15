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
			$body = ($bodySplunk | ConvertTo-Json -Depth $JsonDepth)
			$specialDashes = '[\u2013\u2014\u2015]'
			$specialSingleQuotes = '[\u2018\u2019\u201A\u201B]'
			$specialDoubleQuotes = '[\u201C\u201D\u201E]'
			$body  = $body -replace $specialDashes,"-" -replace $specialSingleQuotes,"'" -replace $specialDoubleQuotes,'\"'

			$body = [Regex]::Replace($body,
				"(?<=[^\\])\\u(?<Value>[a-zA-Z0-9]{4})", {
					param($m) ([char]([int]::Parse($m.Groups['Value'].Value,
						[System.Globalization.NumberStyles]::HexNumber))).ToString() } )
		    while (-not $completed) {
				try {
					$response = Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing -Body $clean -Method Post
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
