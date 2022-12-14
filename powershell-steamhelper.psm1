<#


#>
Function Get-GameInfo{
    Param(
       [Parameter(Mandatory=$true)]
       [string] $appId
    )
    $appInfo = Invoke-WebRequest -URI "http://store.steampowered.com/api/appdetails?appids=$appId&format=json&l=de" -UseBasicParsing
    $appDesc = $appInfo.Content | ConvertFrom-Json
    return $appDesc.$appId
}



Export-ModuleMember -Function Get-GameInfo