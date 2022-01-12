
[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)]
	[ValidateSet("Top", "Bottom")]
	[string]
	$Position
)

# 0 - Left (doesn't work well)
# 1 - Top
# 2 - Right (doesn't work well)
# 3 - Bottom
enum Position {
	Top = 1
	Bottom = 3
}
# Convert input to int value
$posValue = [Position]$Position

$settings = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3\).Settings
$settings[12] = $posValue

Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3\ -Name Settings -type Binary -Value $settings

Stop-Process -Name explorer
# if explorer doesn't restart, run explorer.exe manually