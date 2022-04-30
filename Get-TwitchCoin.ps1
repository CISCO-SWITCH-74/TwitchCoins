<#
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

    #>

function Get-TwitchCoin {
    param(
        [CmdletBinding()]
        [Parameter(HelpMessage="Use to change the period of the action.")]
        [int]$period=60,
        [Parameter(ParameterSetName=’Save’,
        HelpMessage="Use to save the coinbox position.")]
        [switch]$save
    )

    BEGIN {
        Add-Type -AssemblyName System.Windows.Forms

        if($save){
            Calibrate-Mouse
            if (!(Test-Path -Path ".\position.csv" -PathType Leaf)) {
                Write-Error "position.csv not found"
                Exit
            }
            $position = Import-Csv -Path .\position.csv -Delimiter ";"

            $coinX = [System.Windows.Forms.Cursor]::Position.X=$position[0].x
            $coinY = [System.Windows.Forms.Cursor]::Position.Y=$position[0].y
        }
        else{
            if (!(Test-Path -Path ".\position.csv" -PathType Leaf)) {
                $coinX = [System.Windows.Forms.Cursor]::Position.X
                $coinY = [System.Windows.Forms.Cursor]::Position.Y
            } else {
                $position = Import-Csv -Path .\position.csv -Delimiter ";"

                $coinX = [System.Windows.Forms.Cursor]::Position.X=$position[0].x
                $coinY = [System.Windows.Forms.Cursor]::Position.Y=$position[0].y
            }
        }

    }
    PROCESS {
        while($True){
            $currentX = [System.Windows.Forms.Cursor]::Position.X
            $currentY = [System.Windows.Forms.Cursor]::Position.Y

            [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($coinX, $coinY)
            Click-MouseButton
            [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($currentX, $currentY)
            Write-Host "$(Get-Date) Click"
            Start-Sleep -Seconds $period
        }
    }
    END {}
}

function Click-MouseButton
{
    $signature=
@' 
        [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
        public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@ 

    $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru 

    $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
    $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
}

function Calibrate-Mouse
{
    $initX = [System.Windows.Forms.Cursor]::Position.X
    $initY = [System.Windows.Forms.Cursor]::Position.Y
    $position = [pscustomobject]@{x = $initX 
                                  y = $initY } 
    $position | Export-CSV -Path .\position.csv -Delimiter ';' -NoTypeInformation
}