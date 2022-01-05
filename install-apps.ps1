if (Test-Path "$env:ProgramFiles/LINQPad7") {
	Write-Host "LINQPad7 already installed"
} else {
    Write-Host "Installing LINQPad7"
	winget install LINQPad7
	New-Item -ItemType Junction -Target "${env:USERPROFILE}\OneDrive\LinqPad\LINQPad Queries" -Path "$env:ProgramFiles/LINQPad7/queries"
	New-Item -ItemType Junction -Target "${env:USERPROFILE}\OneDrive\LinqPad\LINQPad Snippets" -Path "$env:ProgramFiles/LINQPad7/snippets"
	New-Item -ItemType Junction -Target "${env:USERPROFILE}\OneDrive\LinqPad\LINQPad Plugins" -Path "$env:ProgramFiles/LINQPad7/plugins"
}


if (Test-Path "c:\tools") {
	Write-Host "Tools folder already exists"
} else {
    Write-Host "Setting up Tools folder"
	New-Item -ItemType Junction -Path c:\tools\ -Target "${env:USERPROFILE}\OneDrive - leeksfamily\Tools"
	$p = [Environment]::GetEnvironmentVariable("PATH", "User")
	if (-not $p.Contains("c:\tools")) {
		[System.Environment]::SetEnvironmentVariable("PATH", "${p};c:\tools", "User")
	}
}

$svc = Get-Service -name ssh-agent
if ($svc.Status -eq "Running"){
	Write-Host "SSH-Agent already running"
} else {
    Write-Host "Starting SSH-Agent"
	Set-Service -Name ssh-agent -StartupType Automatic
	Start-Service -name ssh-agent
	Write-Host "Ensure .ssh folder is set up"
}

if ( (get-command -name git -ErrorAction SilentlyContinue) -eq $null){
	Write-Host "Installing git"
	winget install git.git
} else {
	Write-Host "git already installed"
}

if ( (get-command -name code -ErrorAction SilentlyContinue) -eq $null){
	Write-Host "Installing VS Code"
	winget install vscode
} else {
	Write-Host "VS Code already installed"
}

if ( (get-command -name docker -ErrorAction SilentlyContinue) -eq $null){
	Write-Host "Installing Docker Desktop"
	winget install docker.dockerdesktop
} else {
	Write-Host "Docker Desktop already installed"
}


