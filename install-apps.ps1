# Pre-reqs
#
# - wsl installed

if (Test-Path "$env:ProgramFiles/LINQPad7") {
	Write-Host "✅ LINQPad7 already installed"
}
else {
	Write-Host "👟 Installing LINQPad7"
	winget install LINQPad7
	New-Item -ItemType Junction -Target "${env:USERPROFILE}\OneDrive\LinqPad\LINQPad Queries" -Path "$env:ProgramFiles/LINQPad7/queries"
	New-Item -ItemType Junction -Target "${env:USERPROFILE}\OneDrive\LinqPad\LINQPad Snippets" -Path "$env:ProgramFiles/LINQPad7/snippets"
	New-Item -ItemType Junction -Target "${env:USERPROFILE}\OneDrive\LinqPad\LINQPad Plugins" -Path "$env:ProgramFiles/LINQPad7/plugins"
}


if (Test-Path "c:\tools") {
	Write-Host "✅ Tools folder already exists"
}
else {
	if (Test-Path "${env:USERPROFILE}\OneDrive - leeksfamily\Tools") {
		Write-Host "👟 Setting up Tools folder"
		New-Item -ItemType Junction -Path c:\tools\ -Target "${env:USERPROFILE}\OneDrive - leeksfamily\Tools"
		$p = [Environment]::GetEnvironmentVariable("PATH", "User")
		if (-not $p.Contains("c:\tools")) {
			[System.Environment]::SetEnvironmentVariable("PATH", "${p};c:\tools", "User")
		}
	}
 else {
		Write-Host "⚠️ Ensure leeksfamily OneDrive is configured"	
	}
}

$svc = Get-Service -name ssh-agent
if ($svc.Status -eq "Running") {
	Write-Host "✅ SSH-Agent already running"
}
else {
	Write-Host "👟 Starting SSH-Agent"
	Set-Service -Name ssh-agent -StartupType Automatic
	Start-Service -name ssh-agent
	Write-Host "⚠️ Ensure .ssh folder is set up"
}

if ( $null -eq (get-command -name git -ErrorAction SilentlyContinue)) {
	Write-Host "👟 Installing git"
	winget install git.git
}
else {
	Write-Host "✅ git already installed"
}

if ( $null -eq (get-command -name gh -ErrorAction SilentlyContinue)) {
	Write-Host "👟 Installing GitHub CLI"
	winget install github.cli
}
else {
	Write-Host "✅ GitHub CLI already installed"
}

if ( $null -eq (get-command -name code -ErrorAction SilentlyContinue)) {
	Write-Host "👟 Installing VS Code"
	winget install vscode
}
else {
	Write-Host "✅ VS Code already installed"
}

if ( $null -eq (get-command -name docker -ErrorAction SilentlyContinue)) {
	Write-Host "👟 Installing Docker Desktop"
	winget install docker.dockerdesktop
}
else {
	Write-Host "✅ Docker Desktop already installed"
}


if (Test-Path "${env:USERPROFILE}\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json") {
	Write-Host "✅ Terminal Preview already installed"
} else {
	Write-Host "👟 Installing Terminal Preview"
	winget install Microsoft.WindowsTerminal.Preview
	if (Test-Path "${env:USERPROFILE}\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json") {
		Move-Item "${env:USERPROFILE}\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json" "${env:USERPROFILE}\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings-orig.json"
	}
}
if ([bool]((get-item  C:\Users\stuartle\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json).Attributes -band "ReparsePoint")) {
	Write-Host "✅ Terminal Preview settings already symlinked"
} else {
	Write-Host "👟 Symlinking Terminal Preview settings"
	New-Item -ItemType SymbolicLink -Path "${env:USERPROFILE}\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json" -Target "c:\tools\config\windows-terminal\settings.json"
}


if ($null -eq (get-module -name posh-git -ListAvailable)) {
	Write-Host "👟 Installing posh-git"
	Install-Module posh-git -Scope CurrentUser
} else {
	Write-Host "✅ posh-git already installed"
}