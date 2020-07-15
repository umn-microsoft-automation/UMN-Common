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

}
