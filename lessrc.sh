# =============================================================================
# LESS
# =============================================================================

# This file cannot be used by `lesskey` because it has external commands
# (i.e., `tput`) in it, along with environment variables

#export LESS_TERMCAP_DEBUG=1  # Used to see LESS tags
if [[ $- == *i* ]]; then
    export LESS_TERMCAP_mb=$(tput blink; tput setaf ${TPUT_AF_RED})  # Blink
    export LESS_TERMCAP_mh=$(tput dim; tput setaf ${TPUT_AF_GREEN})  # Dim ("half-bright")
    export LESS_TERMCAP_md=$(tput bold; tput setaf ${TPUT_AF_BLUE})  # Bold ("double-bright")
    export LESS_TERMCAP_us=$(tput smul; tput setaf ${TPUT_AF_YELLOW})  # Underline
    export LESS_TERMCAP_ue=$(tput rmul; tput setaf ${TPUT_AF_WHITE})  # Underline Off
    export LESS_TERMCAP_so=$(tput smso; tput setaf ${TPUT_AF_MAGENTA})  # Standout
    export LESS_TERMCAP_se=$(tput rmso; tput setaf ${TPUT_AF_WHITE})  # Standout Off
    export LESS_TERMCAP_mr=$(tput rev; tput setaf ${TPUT_AF_CYAN})  # Reverse
    export LESS_TERMCAP_me=$(tput sgr0; tput setaf ${TPUT_AF_WHITE})  # All Off
fi

