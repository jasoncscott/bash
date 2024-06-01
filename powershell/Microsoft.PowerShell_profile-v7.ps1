# =============================================================================
# PowerShell 7 (`.rc`)
# =============================================================================

# =============================================================================
# VARIABLES
# =============================================================================

${LOCATION} = 'home'  # ad, bc, bo, cave, etc.


# =============================================================================
# INPUTRC (Readline init file)
# =============================================================================

# Readline run commands (`inputrc`)
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# =============================================================================
# GIT
# =============================================================================

Import-Module posh-git

${GitPromptSettings}.DefaultPromptWriteStatusFirst = $True
${GitPromptSettings}.DefaultPromptAbbreviateHomeDirectory = $True

${GitPromptSettings}.BeforeStatus = '(branch: '
${GitPromptSettings}.AfterStatus = ')'
${GitPromptSettings}.BranchColor.ForegroundColor = [ConsoleColor]::Green
${GitPromptSettings}.EnableFileStatus = $True

${GitPromptSettings}.DefaultPromptPath.ForegroundColor = [ConsoleColor]::White
${GitPromptSettings}.DefaultPromptBeforeSuffix.Text = '`n'
${GitPromptSettings}.DefaultPromptSuffix = '> '


# =============================================================================
# PROMPT
# =============================================================================

function prompt {
    # Your non-prompt logic here
    ${prompt} = Write-Prompt "`n"

    # Location
    ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::Red) " ${LOCATION}".ToUpper()

    ${prompt} += ' | '

    # Prompt Timestamp
    ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::Green) (Get-Date -Format 'HH:mm:ss')

    ${prompt} += ' | '

    # Host and OS
    #${prompt} += Write-Prompt "${Env:COMPUTERNAME}".ToLower()  # Doesn't match `bash` `ps1` `\h`
    ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::Blue) (hostname)  # To match `bash` `ps1` `\h`
    ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::Blue) ' ('
    ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::Blue) ${Env:OS}
    ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::Blue) ')'

    ${prompt} += ' | '

    # User
    ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::White) ${Env:USERNAME}

    ${prompt} += ' | '

    # Shell
    ${shell_type} = ${ShellId}.split('.')[-1]
    ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::Yellow) "Shell: ${shell_type}"

    ${prompt} += Write-Prompt "`n"

    ${prompt} += Write-Prompt 'Git Repo: '

    if (Test-Path -Path "${pwd}\.git") {
        ${GIT_REPO} = (Split-Path (git config --get remote.origin.url) -LeafBase).ToUpper()
        ${DIRECTORY_INFO} = "${GIT_REPO} "

        #${GIT_PS1_DESCRIBE_STYLE} ='branch'  # Linux only
        #${GIT_PS1_HIDE_IF_PWD_IGNORED} =
        #${GIT_PS1_SHOWCOLORHINTS} = $True  # Linux only
        #${GIT_PS1_SHOWDIRTYSTATE} = $True  # Linux only
        #${GIT_PS1_SHOWSTASHSTATE} = $True  # Linux only
        #${GIT_PS1_STATESEPARATOR} = '|'  # Linux only

        ${prompt} += Write-Prompt -ForegroundColor ([ConsoleColor]::White) ${DIRECTORY_INFO}
    } else {
        ${DIRECTORY_INFO} = "Not in a repository"
        ${prompt} += Write-Prompt ${DIRECTORY_INFO}
    }

    ${GitPromptSettings}.BeforePath.Text = '`n'
    ${prompt} += & ${GitPromptScriptBlock}


    if (${prompt}) {
        "${prompt}"
    } else {
        ""
    }
}

function pprintvar($var) {
    ${line} = '${' + ${var} + '}: ' + (Get-ChildItem -Path ${var}).Value
    Write-Host ${line}
}

Write-Host "`n"

# System Information (could use `lscpu` or `uname`, but doesn't run on Windows)
Write-Host -ForegroundColor DarkGray -BackgroundColor DarkRed 'System Information'
Write-Host "Processor Model: "#$(grep 'model name' /proc/cpuinfo -m 1 | sed 's|.*:\s*||')\n" 
Write-Host "Cores: "#$(grep 'core id' /proc/cpuinfo | sort | uniq | wc -l)\n"
Write-Host "Threads: "#$(grep 'processor' /proc/cpuinfo | wc -l)\n"
Write-Host "Memory: "#$(grep 'MemTotal' /proc/meminfo | sed 's|.*:\s*||' | awk '{print $1/1024000}' | sed 's|\..*||')GB\n"
Write-Host ''

# OS Information
Write-Host -ForegroundColor DarkGray -BackgroundColor DarkYellow 'OS Information'
pprintvar 'Env:OS'
Write-Host '${OSTYPE}'
Write-Host 'Currnet OS Options: '
Write-Host ''

# Shell Information
Write-Host -ForegroundColor DarkGray -BackgroundColor DarkGreen 'Shell Information'
Write-Host 'Current Shell Options:'
Write-Host ''
Write-Host ''

# PowerShell Information
Write-Host -ForegroundColor DarkGray -BackgroundColor DarkBlue 'PowerShell Information'
Write-Host "PSVersion: " ${PSVersionTable}.PSVersion.ToString()
Write-Host ''
Write-Host ''

# Users
Write-Host -ForegroundColor DarkGray -BackgroundColor White 'Users'
Split-Path (Get-CimInstance -ClassName Win32_ComputerSystem).Username -LeafBase