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
