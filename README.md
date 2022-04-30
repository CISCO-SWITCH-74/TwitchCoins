.SYNOPSIS
Click and move mouse periodically.

.DESCRIPTION
Collect automatically Twitch coins by moving mouse, click, and move back mouse.
If you used save opion before it will get coinbox position in the CSV file

.PARAMETER Save
Save the coin box position in a CSV file.

.PARAMETER Period
Change the period of the click (default 60 seconds).

.INPUTS
None. You cannot pipe objects to Get-TwitchCoin.

.OUTPUTS
None. There is no output.

.EXAMPLE
PS> Get-TwitchCoin -period 120
04/29/2022 21:23:23 Click

.EXAMPLE
PS> Get-TwitchCoin -save -period 600
04/29/2022 21:23:23 Click

.LINK
Online version: https://github.com/CISCO-SWITCH-74/TwitchCoins

> Get-Command Get-TwitchCoin -Syntax
> Get-help Get-TwitchCoin
> Get-Help Get-TwitchCoin -Parameter *