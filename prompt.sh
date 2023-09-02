# =============================================================================
# PROMPT
# Using Cascadia Code PL
# =============================================================================

# =============================================================================
# __git_ps1 PRE
# =============================================================================

.__git_ps1_pre() {
    printf "\n"

    # Return/exit status of last command
    if [ ${exit_status} != 0 ]; then
        true
    else
        true
    fi

    # Location
    printf "${Black}${On_Red}"
    printf "${White}${On_Red}"
    printf '  %4s ' ${LOCATION}
    printf "${Red}${On_Green}"

    # Prompt Timestamp
    printf "${White}${On_Green}"
    printf ' 󱑎 \\t '
    printf "${Green}${On_Blue}"

    # Host and OS
    printf "${White}${On_Blue}"
    printf ' 󰍹  \\h'
    if [[ "${OS}" == 'Windows_NT' ]]; then
        printf " (${OS}) "
    elif [[ ${OSTYPE} = darwin* ]]; then
        printf ' (Mac OS-'
    else
        printf '   '
    fi
    #printf "$(arch)"
    #printf " ) "
    printf "${Blue}${On_Black}"

    # User
    printf "${White}${On_Black}"
    printf '  \\u '
    printf "${Black}${On_Cyan}"

    # Shell Level
    printf "${Black}${On_Cyan}"
    shell_type=$(echo ${SHELL} | sed 's|.*/||')
    if [[ ${BASH_VERSION} = 3* ]]; then
        printf " Shell: ${shell_type} (SHLVL: ${SHLVL}$(.subshell)) "
    else
        printf " SHLVL: ${SHLVL}$(.subshell) "
    fi
    printf "${Cyan}${On_Purple}"

    # Local / Remote / Docker
    printf "${Black}${On_Purple}"
    printf " $(.remote) "
    printf "${Purple}${On_Yellow}"

    # Pipeline
    printf "${Black}${On_Yellow}"
    printf " $(.show_variables) "
    printf "${Color_Off}${Yellow}"

    printf "${Color_Off}"
}


# =============================================================================
# HOSTNAME
# =============================================================================

.host() {
    host_field_size=10

    USER_HOST_LOC=USER_HOST_${M_LOCATION}
    case ${HOSTNAME} in
        ${!USER_HOST_LOC})
            hostname_printed="MAIN ${M_LOCATION} HOST - ${HOSTNAME}"
            ;;
        ${USER_HOST_GUAC}*)
            hostname_printed='GUACAMOLE'
            ;;
        [[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]*)
            hostname_printed='DOCKER'
            ;;
        *)
            hostname_printed=${HOSTNAME}
            ;;
    esac

    if [ $((${#hostname_printed}%2)) -ne 0 ]; then
        hostname_printed=" ${hostname_printed}"
    fi

    padding_total=$((${host_field_size}-${#hostname_printed}))
    padding=$((${padding_total}/2))
    printf '%*s%s%*s' ${padding} '' "${hostname_printed}" ${padding} ''
}


# =============================================================================
# SHLVL
# =============================================================================

if [ -z ${SHLVL_INIT} ] && [[ $- == *i* ]]; then
    export SHLVL_INIT=${SHLVL}
fi

.subshell() {
    if [ ${SHLVL} -gt ${SHLVL_INIT} ]; then
        printf " \e[5;3;4m(Subshell)"
    fi

    if ! [ -z ${REZ_USED_VERSION} ]; then
        printf " \e[5;3;4m(REZ)${Color_Off}${Black}${On_Cyan}"
    fi
}


# =============================================================================
# LOCAL / REMOTE / DOCKER
# =============================================================================

.remote() {
    #ssh_process=$(ps -no-headers -o comm ${PPID} | grep "sshd")
    ssh_process=$(ps -p ${PPID} | grep "sshd")

    if [ "${ssh_process}" == "sshd" ]; then
        printf "\e[7mRemote"
    else
        #if [ -f "/proc/*/cgroup" && "$(grep docker /proc/*/cgroup)" ]; then
        #    printf "\e[7;3;4mDocker"
        #    echo -ne "\033]0;Docker\007"
        #else
            printf "Local"
        #fi
    fi
}


# =============================================================================
# PIPELINE
# =============================================================================

# Set default values for variables that don't exist yet
.show_variables() {
    #if [ -z "${SHOW}" ]; then printf "[none]"; else printf "${SHOW}"; fi
    if [ -z "${SHOW}" ]; then printf "show"; else printf "${SHOW}"; fi
    #if [ -z "${SEQUENCE}" ]; then printf "/[none]"; else printf "/${SEQUENCE}"; fi
    if [ -z "${SEQUENCE}" ]; then printf "/sequence"; else printf "/${SEQUENCE}"; fi
    #if [ -z "${SHOT}" ]; then printf "/[none]"; else printf "/${SHOT}"; fi
    if [ -z "${SHOT}" ]; then printf "/shot"; else printf "/${SHOT}"; fi
    #if [ -z "${TASK}" ]; then printf ":[none]"; else printf ":${TASK}"; fi
    if [ -z "${TASK}" ]; then printf ":task"; else printf ":${TASK}"; fi
    #if [ -z "${VIEW}" ]; then printf ":[none]"; else printf ":${VIEW}"; fi
    if [ -z "${VIEW}" ]; then printf " View: [view]"; else printf ":${VIEW}"; fi
}


# =============================================================================
# TITLE
# =============================================================================

.title() {
    #title=$(xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME | awk -F\" '{print $2}')
    title=${HOSTNAME}
    echo -ne "\[\033]0;${title}\a\]";

    # Change Konsole Tab Title
    #if [ -n "${KONSOLE_DBUS_SESSION}" ]; then
    #    qdbus org.kde.konsole ${KONSOLE_DBUS_SESSION} org.kde.konsole.Session.setTitle 1 ${M_LEVEL}:${M_TASK};
    #fi
}


# =============================================================================
# __git_ps1 POST
# =============================================================================

.__git_ps1_post() {
    printf '\n'
    printf "${BIWhite}"

    # Present Working Directory on newline
    printf '\e[38;5;3m '
    printf ${Color_Off}':╭─ '
    printf ${White}'\\w'
    printf ${Color_Off}

    # Put prompt on newline
    printf '\n'
    printf "\[${Red}\] \[${Color_Off}\]"
    #printf " "
    printf ' ╰ '
    .title
}


# =============================================================================
# Git
# =============================================================================

#if [[ ${OSTYPE} = darwin* ]]; then
#    __git_ps1() { : ; }
#fi

# __git_ps1 3 arguments: pre, post, format
.git() {
    exit_status="${?}"

    if [ -d "${PWD}/.git" ] || [ '$(basename "${PWD}")' == ".git" ]; then
        GIT_REPO="$(basename -s .git $(git config --get remote.origin.url))"
        DIRECTORY_INFO="${BIWhite} :${Color_Off} ${White}${Black}${On_White} ${GIT_REPO^^} ${Color_Off}${White}${Color_Off} (branch:"

        GIT_PS1_DESCRIBE_STYLE='branch'
        GIT_PS1_HIDE_IF_PWD_IGNORED=
        GIT_PS1_SHOWCOLORHINTS=true
        GIT_PS1_SHOWDIRTYSTATE=true
        GIT_PS1_SHOWSTASHSTATE=true
        GIT_PS1_STATESEPARATOR='|'

        # Git repos with <500 files
        if [ $(git ls-files | wc -l) -lt 500 ]; then
            GIT_PS1_SHOWUNTRACKEDFILES=true
            GIT_PS1_SHOWUPSTREAM='verbose name'
            #PS1=${__git_ps1_pre}${__git_ps1_post}
            __git_ps1 "$(.__git_ps1_pre)\n${DIRECTORY_INFO}" "$(.__git_ps1_post)" " %s)"
        # Git repos with >=500 files
        else
            GIT_PS1_SHOWUNTRACKEDFILES=false
            GIT_PS1_SHOWUPSTREAM=
            #DIRECTORY_INFO+=' (Repository is too large to show untracked files and verbose display)'
            __git_ps1 "$(.__git_ps1_pre)\n${DIRECTORY_INFO}" "$(.__git_ps1_post)" " %s)"
        fi
    else
        DIRECTORY_INFO="${BIWhite} :${Color_Off} Not in a repository"
        __git_ps1 "$(.__git_ps1_pre)\n${DIRECTORY_INFO}" "$(.__git_ps1_post)" " %s)"
    fi

    # TODO: Account for bare repos
}


# =============================================================================
# PROMPT_COMMAND (using __git_ps1)
# =============================================================================

export PROMPT_COMMAND='.git'
