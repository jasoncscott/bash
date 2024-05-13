# =============================================================================
# Pitch Black Aliases
# =============================================================================

# =============================================================================
# GLOBALS
# =============================================================================

# Hosts
#export USER_HOST_<LOC>="<host>"


# =============================================================================
# APPLICATIOONS
# =============================================================================

alias deadline="rez-env deadline_client -- deadlinemonitor -new"
#alias deadline-custom="${HOME}/Documents/Development/git/deadline/custom/ deadline"
#alias lolcat="rez-env lolcat -- lolcat"
#alias nvtop="rez-env nvtop -- nvtop"
#alias teams="google-chrome --profile-directory='Profile 1' --app-id=cifhbcnohmdccbgoicgdjpfamggdegmo"
#alias vscode="rez-env visual_studio_code python-3 -- code"  # pylint black -- code
#alias vscode-cli="rez-env visual_studio_code -- code-cli"


# =============================================================================
# NAVIGATION
# =============================================================================

# Datacenters
#alias <LOC>="ssh ${USER_HOST_<LOC>}"
alias bl_wc="cd /c/bl/pkgs/blizzard/bl/pkg/t2/dept/engine/wowcreator/"

# =============================================================================
# FUNCTIONS
# =============================================================================

#_proj_complete() {
#    local project
#
#    for project in /<proj dir>/"${2}"*; do
#        COMPREPLY+=($(basename "${project}"))
#    done
#}
#complete -F _proj_complete proj

# =============================================================================

eg() {
    grep -R "${@}" Engine/Tools/WowCreator/
}

# =============================================================================

#proj() {
#    if [ -d "/<proj_dir>/${1}" ]; then
#        cd /<proj_dir>/${1}
#        PROJECT=${1}
#    else
#        cd /<proj_dir>/
#    fi
#}

# =============================================================================

rdiff() {
    local host="USER_HOST_${2^^}"

    if [ -z ${!host} ]; then
        echo "Invalid location"
    else
        ssh ${!host} "cat $(readlink -f ${1})" | diff --report-identical-files ${1} -
    fi
    #if [ "${2}" = "<LOC>" ]; then
    #    ssh ${USER_HOST_<LOC>} "cat $(readlink -f ${1})" | diff ${1} -
    #else echo "Invalid location" fi
}

# =============================================================================

rmeld() {
    local host="USER_HOST_${2^^}"

    if [ -z ${!host} ]; then
        echo "Invalid location"
    else
        ssh ${!host} "cat $(readlink -f ${1})" | meld ${1} -
    fi
}

# =============================================================================

#unalias ssh
#.ssh() {
#    if [ ! -f /]
#}
