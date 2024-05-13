# =============================================================================
# Personal Aliases
# =============================================================================

# =============================================================================
# BACKGROUNDING
# =============================================================================

alias chrome='chrome &'
alias firefox='firefox &'
alias fox='firefox &'
alias kcalc='kcalc &'
alias pidgin='pidgin &> /dev/null &'


# =============================================================================
# DEFAULT OPTIONS/FLAGS
# =============================================================================

alias bat='bat --theme="OneHalfDark"'
alias bat-help='bat --plain --language=help --paging=never'
alias batdiff='git diff --name-only --relative --diff-filter=d | xargs bat --diff'
alias bottom='btm --config ${HOME}/Documents/shell/bottom/bottom.toml'
alias bpython="rez-env bpython -- bpython"
alias cal='cal -3'
alias cat='bat'
alias chgrp='chgrp --changes'
alias chmod='chmod --changes'
alias chown='chown --changes'
alias date='date +%Y-%m-%d'
#alias df='df -hT'
alias df='duf'
#alias diff='diff --color=auto'
alias diff='delta'
#alias du='du -b'
#alias du='diskus -b'
alias eza='eza --header --icons --group --time-style iso --created --modified --accessed --group-directories-first --sort Name --colour=auto --classify --all'
alias gitlog='git log --graph --oneline'
alias grep='grep --ignore-case --color=auto'
alias htop='XDG_CONFIG_HOME=${HOME}/Documents/shell btop'
#alias ls='ls --almost-all --classify --group-directories-first -Cv --color=auto'
alias ls='eza'
alias pylint='pylint --reports=n'
alias rsp='ssh -L 1715:houdini.lic.rsp.com.au:1715 -L 5053:nuke.lic.rsp.com.au:5053 -L 50386:nuke.lic.rsp.com.au:50386 jscott@xfer.rsp.com.au'
alias rsync='rsync --verbose --progress --recursive --links --perms --times --omit-dir-times --owner --devices --specials'
    # Not group, because Groups don't match across locations
    #-a = --(r)ecursive --(l)inks --(p)erms --(t)imes --(g)roup --(o)wner (--devices --specials)(-D) (no -H,-A,-X)
alias scottCiscoLinksysE2000='ssh root@192.168.1.1'  # 2wsdR5tg
alias scottMyCloud01='ssh sshd@192.168.1.11'  # 2wsdR5tg
alias ssh="ssh -Y"
#alias ssh='ssh -c arcfour128,arcfour,blowfish-cbc -Y'
alias strings="//live.sysinternals.com/tools/strings"
alias sudo='sudo '
alias top='htop'
#alias tree='tree -afpsugCD -I ".snapshot|.git|build"'
alias tree='eza --tree --long --ignore-glob=".git"'
#alias type='type -P'

# Linux Only
#if [[ ${OSTYPE} = linux* ]]; then
#fi


# =============================================================================
# NAVIGATION
# =============================================================================

alias bin='cd ${HOME}/Documents/bin/'
alias dev='cd /z/Development/'
alias docs='cd ${HOME}/Documents/'
alias downloads='cd ${HOME}/Downloads/'
alias fonts='cd ${HOME}/.fonts/'
alias personal='cd /Volumes/Projects/Production/Personal/${USER}/'
alias repos='cd ${HOME}/Documents/Development/git/rez/repos/'
alias tmp='cd ${HOME}/TMP/'


# =============================================================================
# REMAPPING
# =============================================================================

alias acroread='evince'
alias tkdiff='xxdiff'


# =============================================================================
# OVERLOADING
# =============================================================================

unalias du 2>/dev/null
.du() {
    if [ $# -eq 0 ]; then
        diskus
    else
        local disksize_list=''

        for item in $@; do
            item_disksize_raw=$(diskus --apparent-size ${item} | numfmt --to iec)

            if [[ ${item_disksize_raw} == *K ]]; then
                item_disksize_colour=${Blue}$(printf '%4s' ${item_disksize_raw})${Color_Off}
            elif [[ ${item_disksize_raw} == *M ]]; then
                item_disksize_colour=${Green}$(printf '%4s' ${item_disksize_raw})${Color_Off}
            elif [[ ${item_disksize_raw} == *G ]]; then
                item_disksize_colour=${Red}$(printf '%4s' ${item_disksize_raw})${Color_Off}
            else
                item_disksize_colour=$(printf '%4s' ${item_disksize_raw})
            fi

            printf "${item_disksize_colour}\t${item}\n"
        done
    fi
}
alias du='.du'
# =============================================================================
unalias groups 2>/dev/null
.groups() {
    if [ $# -eq 0 ]; then
        set -- ${USER}
    fi

    for user in ${@}; do
        echo ${user}
        \groups ${user} | sed 's|^.*: ||' | sed 's| |\n|g' | sort | nl
    done
}
alias groups='.groups'
# =============================================================================
unalias help 2>/dev/null
.help() {
    "$@" --help 2>&1 | bat-help
}
alias help='.help'
# =============================================================================
unalias id 2>/dev/null
.id() {
    \id ${@} | sed 's|[ ,]|\n|g' | sed 's|groups=|groups=\n|' | nl -b 'p^[0-9]'
}
alias id='.id'
alias ids='.id'
# =============================================================================
unalias ll 2>/dev/null
.ll() {
    if [[ ${OSTYPE} = linux* ]]; then
        local OPTIND A SNACL
        while getopts "A" options; do
            printf "${OPTARG}"
            case "${options}" in
                A)
                    SNACL=true
                    shift $((OPTIND-1))
                    ;;
                *)
                    #set -- "${@}" "${options}"
                    ;;
            esac
        done

        if [ "${SNACL}" = true ]; then
            printf "\e[4;38m"
            printf "\nAccess Control Lists\n"
            printf "${Color_Off}"

            #snacl -l ${@}
            snacl-formatted.py ${@}
        fi

        eza --long ${@}
    else
        ls -lAh --color=always "${@}"
        #ls -lAh --color=always "${@}"" | more  # Only if `more` is installed
    fi
}
alias ll='.ll'
# =============================================================================
#unalias snacl 2>/dev/null
#.snacl() {
#    snacl-formatted.py "${@}""
#}
#alias snacl='.snacl'
# =============================================================================
if [[ "${OS}" == 'Windows_NT' ]]; then
    alias uptime="//live.sysinternals.com/tools/psinfo Uptime | grep Uptime"
 fi
# =============================================================================
.which() {
    printf 'whatis: '; whatis ${1}
    printf 'which: '; which ${1}
    printf 'whereis: '; whereis ${1}
    printf 'type -a: '; type -a ${1}
}
#alias which='which ${1}; whatis ${1}; help ${1}; info ${1}; apropos ${1}; man -k ${1}'
#alias which='.which'


# =============================================================================
# FUNCTIONS
# =============================================================================

calc() {
    echo "${@}" | bc
}
# =============================================================================
mate-terminal-tab-name () {
    echo -n -e "\033]0;★${1}\007"
}
# =============================================================================
path() {
    echo ${PATH} | sed 's|:|\n|g'
}
# =============================================================================
pprintvar() {
    printf '${'${1}'}: '"${!1}"'\n'
}
# =============================================================================
rez-cd() {
    cd $(rez-search --format='{base}' -s -l "$1")
}
# =============================================================================
rez-list() {
    join -a 1 <(rez-search --format='{qualified_name}: {base}' -s "$1") <(rez-search --format='{qualified_name}: {base}' -s --nl "$1") | sed 's|\( .*\)\1|\1|g'
}
# =============================================================================
screensaver-off() {
    xset dpms force on
}
