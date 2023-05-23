# Powershell-steamhelper

![Publishing Status](https://github.com/randomtoy/powershell-steamhelper/actions/workflows/publish-release-to-psgallery.yaml/badge.svg)

This is small powershell module get some information from Steam WebAPI

This module is available for installation via [Powershell Gallery](http://www.powershellgallery.com/). Simply run the following command:

    Install-Module -Name powershell-steamhelper

## About Module
With this module you can get free information about games and some gamestats from Steam

## Avalable Functions

**Get-GameInfo:** Get main Information about a game from Steam

**Get-GamesByName:** Find games from Steam by pattern (2 minutes cache for gamelist is used for this function)

**Get-SDRConfigForApp:** Get some configs for a game (revision, addresses for available servers, typical pings for these servers)

**Get-SteamNewsForApp:** Get news for a game. Can be set with various params (Count, Date, Tags etc)

**Get-GlobalAchievementPercentagesForApp:** Get global achievements for game (unfortunately it is not possible to get the description of the achievement using the Free API)

**Get-NumberOfCurrentPlayersForApp:** Get number of current players for a game
