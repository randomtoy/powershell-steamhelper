# Function Get-GlobalAchievementForApp {
#     Param(
#         # Application ID
#         [Parameter(Mandatory=$true)]
#         [string]
#         $AppId
#     )
# #    $AppInfo = Invoke-WebRequest -URI "http://api.steampowered.com/ISteamUserStats/GetGlobalStatsForGame/v0001/?appid=$AppId" -UseBasicParsing
#     $appInfo = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?appid=1245620&key=172A0F85C7E41F0535949A92798BD399" -UseBasicParsing
# #    $appDesc = $appInfo.Content | ConvertFrom-Json
#     return $appInfo.Content | ConvertFrom-Json
# }



# #(Get-GlobalAchievementForApp -AppId 1245620).achievementpercentages.achievements
# (Get-GlobalAchievementForApp -AppId 1245620).game.availableGameStats.achievements | Format-Table
# # # Function Get-GameInfo2{

# #     $appInfo = Invoke-WebRequest -URI "http://api.steampowered.com/ISteamApps/GetAppList/v0002/" -UseBasicParsing
# #     $appDesc = $appInfo.Content | ConvertFrom-Json
# #     # return $appDesc
# #     foreach ($appname in $appDesc.applist.apps) {
# #         Write-Progress -Activity 'Processing games'
# #         <# $appname is the current item #>
# #         if ($appname.name -match "elden") {
# #             <# Action to perform if the condition is true #>
# #             Write-Output $appname.name
# #         }
# #         #Write-Output $appname.name
# #     }
# #     #Write-Output $appDesc.applist.apps
# # #Write-Output $appDesc= $appInfo.Content | ConvertFrom-Json
# # #}

# # #Get-GameInfo2

# #Invoke-WebRequest -URI "https://steamdb.info/app/1245620/stats" -UserAgent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36'

$AppInfo