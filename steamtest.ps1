# Function Get-GameInfo2{

    $appInfo = Invoke-WebRequest -URI "http://api.steampowered.com/ISteamApps/GetAppList/v0002/" -UseBasicParsing
    $appDesc = $appInfo.Content | ConvertFrom-Json
    # return $appDesc
    foreach ($appname in $appDesc.applist.apps) {
        Write-Progress -Activity 'Processing games'
        <# $appname is the current item #>
        if ($appname.name -match "elden") {
            <# Action to perform if the condition is true #>
            Write-Output $appname.name
        }
        #Write-Output $appname.name
    }
    #Write-Output $appDesc.applist.apps
#Write-Output $appDesc= $appInfo.Content | ConvertFrom-Json
#}

#Get-GameInfo2

