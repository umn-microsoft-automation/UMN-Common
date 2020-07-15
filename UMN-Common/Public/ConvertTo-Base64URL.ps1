function ConvertTo-Base64URL
{
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
