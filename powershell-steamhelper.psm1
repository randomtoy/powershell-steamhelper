<#


#>

class GamesList {
    # TimeStamp
    [datetime] $TimeStamp;

    # Command Name
    [string] $Name;

    # Command 
    [scriptblock] $Command;

    #output
    [PSCustomObject] $Value;

    GamesList ([string] $name, [ScriptBlock] $scriptblock){
        $this.TimeStamp = [datetime]::UtcNow;
        $this.Name = $name;
        $this.Command = $scriptblock;
        $this.Value = $scriptblock.Invoke()
    }
}

function Get-CachedGamesList([string]$Name, [scriptblock]$command) {
    $CommandName = "cached_$($name)"
    $cachedResults = Get-Variable -Scope Global -Name $CommandName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value
    
    if($null -eq $cachedResults -or ($cachedResults.TimeStamp -le [DateTime]::UtcNow.AddMinutes(-2))){
        Write-Verbose "caching..."
        $GamesList = [GamesList]::new($name,$command)
        New-Variable -Scope Global -Name $CommandName -value $GamesList -Force
        $cachedResults = $GamesList
    } else {
        Write-Verbose "found cache"
    }
    return $cachedResults.Value
}
    
Function Invoke-GamesList {

    $appInfo = Invoke-WebRequest -URI "http://api.steampowered.com/ISteamApps/GetAppList/v0002/" -UseBasicParsing
    $appDesc = $appInfo.Content | ConvertFrom-Json
    $appSort = $appDesc.applist.apps | Sort-Object -Property 'name'
   
    return $appSort
}

Function Get-SteamGameInfo{
    Param(
       [Parameter(Mandatory=$true)]
       [string] $appId
    )
    $appInfo = Invoke-WebRequest -URI "http://store.steampowered.com/api/appdetails?appids=$appId&format=json&l=de" -UseBasicParsing
    $appDesc = $appInfo.Content | ConvertFrom-Json
    return $appDesc.$appId
}

Function Get-SteamGamesByName {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $gamePattern
    )
    $gamesResult = Get-CachedGamesList -Name "ALL_GAMES" -command(
        [scriptblock]::Create({
            Invoke-GamesList
        })
    ) | Where-Object -Property 'name' -Like "*$gamePattern*"

    return $gamesResult

}

Function Get-SteamSDRConfigForApp {
    Param(
        # Application ID
        [Parameter(Mandatory=$true)]
        [string]
        $AppId
    )
    $appInfo = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamApps/GetSDRConfig/v0001/?appid=$AppId" -UseBasicParsing
    return ($appInfo.Content | ConvertFrom-Json)
}

Function Get-SteamNewsForApp {
    param (
        # Application ID
        [Parameter(Mandatory=$true)]
        [string]
        $AppID,
        # Max length for content
        [parameter(Mandatory=$false)]
        [uint32]
        $MaxLength,
        # Retrive posts earlier than this date (unix epoch timestamp)
        [Parameter(Mandatory=$false)]
        [uint32]
        $EndDate,
        # Number of posts to retrieve (default 20)
        [Parameter(Mandatory=$false)]
        [uint32]
        $Count,
        # Comma-separated list of feed names to return news for
        [Parameter(Mandatory=$false)]
        [string]
        $Feeds,
        # Comma-separated list of tags to filter by (e.g. 'patchnodes')
        [Parameter(Mandatory=$false)]
        [string]
        $Tags
    )
    $queryString = "?appid=$AppId"
    if ($MaxLength){
        $queryString = -join($queryString,"&maxlength=$MaxLength")
    }
    if ($EndDate){
        $queryString = -join($queryString,"&enddate=$EndDate")
    }
    if ($Count){
        $queryString = -join($queryString,"&count=$Count")
    }
    if ($Feeds){
        $queryString = -join($queryString,"&feeds=$Feeds")
    }
    if ($Tags){
        $queryString = -join($queryString,"&tags=$Tags")
    }
    $appInfo = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/$queryString" -UseBasicParsing
    return ($appInfo.Content | ConvertFrom-Json).appnews
  }


Function Get-SteamGlobalAchievementPercentagesForApp {
    Param(
        # Application ID
        [Parameter(Mandatory=$true)]
        [string]
        $AppId
    )
$appInfo = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v2/?gameid=$appId" -UseBasicParsing
return ($appInfo.Content | ConvertFrom-Json).achievementpercentages.achievements
}

Function Get-SteamNumberOfCurrentPlayersForApp {
    Param(
        # Application ID
        [Parameter(Mandatory=$true)]
        [string]
        $AppId
    )
    $appInfo = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1/?appid=$appId" -UseBasicParsing
    return ($appInfo.Content | ConvertFrom-Json).response
}



# New-Alias -Name ggi -Value Get-GameInfo
# New-Alias -Name ggbn -Value Get-GamesByName

Export-ModuleMember -Function Get-SteamGameInfo,Get-SteamGamesByName,Get-SteamSDRConfigForApp,Get-SteamNewsForApp,Get-SteamGlobalAchievementPercentagesForApp,Get-SteamNumberOfCurrentPlayersForApp
#  -Alias ggi,ggbn

