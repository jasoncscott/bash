# =============================================================================
# .bashrc
# =============================================================================

export DOTFILES_LOC="${HOME}/Development/git/Bitbucket+GitHub+GitLab/jasoncscott/dotfiles/"
bash_dir="${DOTFILES_LOC}/bash"

export SOURCED_BASHRC=true

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

bash_profile_file="${HOME}/.bash_profile"
if [ -f "${bash_profile_file}" ] && [ -z "${SOURCED_BASH_PROFILE}" ]; then
    echo "Sourcing ${bash_profile_file}"
    . "${HOME}/.bash_profile"
fi


# =============================================================================
# SETTINGS
# =============================================================================

complete -d cd  # Complete only to directories


# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================

# macOS zsh message
export BASH_SILENCE_DEPRECATION_WARNING=1

# Enabling symlinks in Git Bash for Windows
export MSYS=winsymlinks:nativestrict

# History
export HISTCONTROL=erasedups
export HISTFILESIZE=5000
export HISTIGNORE="&:ls:[bf]g;exit"
export HISTTIMEFORMAT="%F %T"

# Debug
#export LD_DEBUG=libs

# Other variables
export EDITOR="vi"
export LOCATION="home"  # Prompt is set to 4-character padding for location name

if [[ "${OSTYPE}" = "linux"* ]]; then
	export MANPAGER="sh -c 'col --no-backspaces --spaces | bat --language man'"  # No `bat` themes have `man` support as of 0.22.1
	export PAGER="less --quit-if-one-screen --RAW-CONTROL-CHARS"
fi

# Path to VI run commands file
vimrc_file="${DOTFILES_LOC}/vim/vimrc"
if [ -f "${vimrc_file}" ]; then
    export VIMINIT="source ${vimrc_file}"
fi


# =============================================================================

# Function to check for file existence before attempting to source
source-safe() {
    if [ -f "${1}" ]; then
        source "${1}"
    fi
}

# =============================================================================
# INPUTRC (Readline init file)
# =============================================================================

# Path to Readline run commands (init) file
inputrc_file="${bash_dir}/inputrc"
if [ -f "${inputrc_file}" ]; then
    export INPUTRC="${inputrc_file}"
fi

# Source only if interactive shell (test special parameter for "i" option)
if [[ $- == *i* ]]; then
    bind -f ${INPUTRC}
fi


# =============================================================================
# COLORS
# =============================================================================

shell_colors_file="${bash_dir}/shell_colors.sh"
source-safe ${shell_colors_file}

tput_colors_file="${bash_dir}/tput_colors.sh"
source-safe ${tput_colors_file}

# Colors
export LS_COLORS=$(vivid generate snazzy)  # Requires `vivid` package
#export GREP_COLORS=


# =============================================================================
# GIT
# =============================================================================

export GIT_CONFIG_GLOBAL="${DOTFILES_LOC}/git/gitconfig"

# git prompt completion
if [[ "${OS}" == "Windows"* ]]; then
    git_prompt_file="/c/Program\ Files/Git/etc/profile.d/git-prompt.sh"
elif [[ "${OSTYPE}" = "darwin"* ]]; then
    git_prompt_file="${DOTFILES_LOC}/git/git-prompt.sh"
else
    git_prompt_file=/usr/share/git-core/contrib/completion/git-prompt.sh
fi

source-safe ${git_prompt_file}

# git autocomplete
# On systems with `bash-completion` installed
if [[ "${OSTYPE}" = "darwin"* ]]; then
    git_completion_file="${DOTFILES_LOC}/git/git-completion.bash"
else
    git_completion_file=/usr/share/bash-completion/completions/git
fi

source-safe ${git_completion_file}


# =============================================================================
# LESS
# =============================================================================

# Due to desire to use external commands in LESS environment variables (e.g.,
# `tput`), source own file
lessrc_file="${bash_dir}/lessrc.sh"
if [ -f ${lessrc_file} ]; then
    # Can cause slowdown
    printf "\n"
    echo "Not going to" source ${lessrc_file}  # Custom name following `rc` files
fi


# =============================================================================
# PYTHON
# =============================================================================

# Path to Python startup file
pythonstartup_file="${DOTFILES_LOC}/python/pythonstartup"
if [ -f "${pythonstartup_file}" ]; then
    export PYTHONSTARTUP="${pythonstartup_file}"
fi
export PYTHONDONTWRITEBYTECODE=true
#export PYTHONPROFILEIMPORTTIME=true

# Windows does not use these from the shell
#PIP_CONFIG_FILE="${DOTFILES_LOC}/python/pip.ini"
#PIP_TARGET="Z:\Applications_and_Programs\Python_Software_Foundation-python\site-packages"
#PYTHONPATH=${PIP_TARGET}


# =============================================================================
# REZ
# =============================================================================

# Needs to be symlink'd from `~/.rezconfig.py` if there's a "studio" `${REZ_CONFIG_FILE}`
export REZ_CONFIG_FILE="${DOTFILES_LOC}/rez/rezconfig.py"

# `rez` tab-complete
if [[ "${OS}" == "Windows"* ]]; then
    rez_complete_file=/c/rez/production/windows/production/completion/complete.sh
else
    PATH="${PATH}":/mnt/c/rez/production/linux/production/bin/rez  # Add `rez` to ${PATH}
    rez_complete_file=/mnt/c/rez/production/linux/production/completion/complete.sh
fi

source-safe ${rez_complete_file}


# =============================================================================
# VCPKG
# =============================================================================

export VCPKG_DISABLE_METRICS=true


# =============================================================================
# PROMPT
# =============================================================================

prompt_file="${bash_dir}/prompt.sh"
source-safe ${prompt_file}
#eval "$(starship init bash)"
export STARSHIP_CONFIG="${DOTFILES_LOC}/starship/starship.toml"


# =============================================================================
# ADDITIONAL FILES
# =============================================================================

# Source personal aliases
aliases_file="${bash_dir}/aliases.sh"
source-safe "${aliases_file}"

aliases_work_file="${bash_dir}/aliases_work.sh"
source-safe "${aliases_work_file}"

work_env_file="${bash_dir}/work_env.sh"
source-safe "${work_env_file}"


# =============================================================================
# STARTUP INFO
# =============================================================================

.startup_info() {
    printf "\n"

    # System Information (could use `lscpu` or `uname`, but doesn't run on Windows)
    printf "${Black}${On_Red}"
    printf ${Black}${On_Red}" System Information "${Red}""${Color_Off}
    printf "\n"
    printf "Processor Model: $(grep 'model name' /proc/cpuinfo -m 1 | sed 's|.*:\s*||')\n" 
    printf "Cores: $(grep 'core id' /proc/cpuinfo | sort | uniq | wc -l)\n"
    printf "Threads: $(grep 'processor' /proc/cpuinfo | wc -l)\n"
    printf "Memory: $(grep 'MemTotal' /proc/meminfo | sed 's|.*:\s*||' | awk '{print $1/1024000}' | sed 's|\..*||')GB\n"
    printf "GPU: $(lspci | grep VGA)\n"
    printf "\n"

    # OS Information
    printf "${Black}${On_Yellow}"
    printf ${Black}${On_Yellow}" OS Information "${Yellow}${On_Black}""${Color_Off}
    printf "\n"
    pprintvar "OS"
    pprintvar "OSTYPE"
    if [[ "${OSTYPE}" = "darwin"* ]]; then
        printf "$(sw_vers -productVersion).$(sw_vers -buildVersion) ($(awk '/SOFTWARE LICENSE AGREEMENT FOR macOS/' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf' | awk -F 'macOS ' '{print $NF}' | awk '{print substr($0, 0, length($0)-1)}'))\n"
    else
        printf "$(cat /proc/version)\n"
    #printf "$(cat /etc/os-release)\n"
    fi

    printf "Current OS Options (\${MSYS}):"
    # Choose one of the next two lines
    printf " "${MSYS}
    #printf "\n"${MSYS} | sed "s|:|\n|g" | sed "s|^|    |"
    printf "\nFor more information, try \`dmidecode\`"
    printf "\n\n"

    # Shell Information
    printf "${Black}${On_Green}"
    printf ${On_Green}${Black}" Shell Information "${Green}${On_Black}""${Color_Off}
    printf "\n"
    printf "Current Shell Options (\${SHELLOPTS}):"
    # Choose one of the next two lines
    printf " "${SHELLOPTS}
    #printf "\n"${SHELLOPTS} | sed "s|:|\n|g" | sed "s|^|    |"
    printf "\n(Same as Special Variables (\$-): $-)"
    printf "\n\n"

    # Bash Information
    printf "${Black}${On_Blue}"
    printf ${On_Blue}${Black}" Bash Information "${Blue}${On_Black}""${Color_Off}
    printf "\n"
    pprintvar "BASH_VERSION"
    printf "Current Bash Options (\${BASHOPTS}):"
    # Choose one of the next two lines
    printf " "${BASHOPTS}
    #printf "\n"${BASHOPTS} | sed "s|:|\n|g" | sed "s|^|    |"
    printf "\n\n"

    # Users
    printf "${Black}${On_White}"
    printf ${On_IWhite}${Black}" Users "${White}${On_Black}""${Color_Off}
    printf "\n"
    users | sed "s| |\n|g" | uniq | sed "s|^|   |"

    if [ -x "$(command -v fortune)" ]; then
        fortune
    fi

    if [ -x "$(command -v uptime)" ]; then
        uptime
    fi

    # Blizzard
    printf "${Black}${On_Cyan}"
    printf ${On_Cyan}${Black}" Blizzard "${Cyan}${On_Black}""${Color_Off}
    printf "\n"
    pprintvar "PACKAGE_CACHE_PATH"
    pprintvar "BL_TEAM"
    pprintvar "T2_PKG_ROOT"
}

# For Interactive Shells
if [[ $- == *i* ]]; then
    .startup_info
fi

