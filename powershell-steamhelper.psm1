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
    $gamesResult = Get-CachedGamesList -Name "ALL_GAMES" -command(
        [scriptblock]::Create({
            Invoke-GamesList
        })
    ) | Where-Object -Property 'name' -Like "*$gamePattern*"

    return $gamesResult

}

Export-ModuleMember -Function Get-GameInfo
Export-ModuleMember -Function Get-GamesByName
