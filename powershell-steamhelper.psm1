<#


#>
Function Get-CachedGamesList {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory= $true)]
        $Key,
        [Parameter(Mandatory = $true)]
        [scriptblock]
        $ScriptBlock
    )

    $CACHE_VARIABLE_NAME = "GamesList"

    if (-not (Get-Variable -Name $CACHE_VARIABLE_NAME -Scope Global -ErrorAction SilentlyContinue)) {
        Set-Variable -Name $CACHE_VARIABLE_NAME -Scope Global -Value @{}
    }
    $cache = Get-Variable -Name $CACHE_VARIABLE_NAME -Scope Global
    if (-not $cache.Value.ContainsKey($Key)) {
        $cachedValue = &$ScriptBlock
        $cache.Value[$Key] = $cachedValue
    }
    else {
        $cachedValue = $cache.Value[$Key]
    }

    $cachedValue
}

Function Invoke-GamesList {

    $appInfo = Invoke-WebRequest -URI "http://api.steampowered.com/ISteamApps/GetAppList/v0002/" -UseBasicParsing
    $appDesc = $appInfo.Content | ConvertFrom-Json
    $appSort = $appDesc.applist.apps | Sort-Object -Property 'name'
   
    return $appSort
}

Function Get-GameInfo{
    Param(
       [Parameter(Mandatory=$true)]
       [string] $appId
    )
    $appInfo = Invoke-WebRequest -URI "http://store.steampowered.com/api/appdetails?appids=$appId&format=json&l=de" -UseBasicParsing
    $appDesc = $appInfo.Content | ConvertFrom-Json
    return $appDesc.$appId
}

Function Get-GamesByName {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $gamePattern
    )
    $gamesResult = Get-CachedGamesList -Key "ALL_GAMES" -ScriptBlock {
        Invoke-GamesList
    }  | Where-Object -Property 'name' -Like "*$gamePattern*"

    return $gamesResult

}


Export-ModuleMember -Function Get-GameInfo
Export-ModuleMember -Function Get-GamesByName
