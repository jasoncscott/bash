# =============================================================================
# COLORS (SGR) (Select/Set Graphics Rendition)
# =============================================================================

# Note: Windows Terminal only uses Regular and Bold, not Intense

# Reset
Color_Off='\e[0m'  # Text Reset
#Color_Off='$(tput sgr0)'

# tput Usage Examples
# Black='$(tput setf 0)'
# BBlack='$(tput bold)$(tpub setf 0)'

alias .colours=.colors
.colors() {
    # 8-Bit/256 Colors: FG = 38;5;${var}, BG = 48;5;${var} or ${var} can be r;g;b
    printf '\n8-Bit, 256 Colors\n'
    for fgbg in 38 48; do  # Foreground / Background
        for color in {0..255}; do  # Colors
            # Display the color
            printf "\e[${fgbg};5;${color}m  %3s  \e[0m" ${color}

            # Display 16 colors per line
            if [ $(((${color} + 1) % 16)) == 0 ]; then
                printf '\n'  # New line
            fi
        done
    done

    # 4-Bit
    sets[0]='Reset'
    sets[1]='Bold'  # Off = 21 (or Double Underline)
    sets[2]='Dim'  # Off = 22
    sets[3]='Italics'  # Off = 23
    sets[4]='Underlined'  # Off = 24
    sets[5]='Blink Slow'  # Off = 25
    sets[6]='Blink Fast'  # Off = 26
    sets[7]='Reverse'  # Off = 27
    sets[8]='Hidden'  # Off = 28
    sets[9]='Strikeout'  # Off = 29
    sets[53]='Overline'

    colors[0]='Black'
    colors[1]='Red'
    colors[2]='Green'
    colors[3]='Yellow'
    colors[4]='Blue'
    colors[5]='Purple'
    colors[6]='Cyan'
    colors[7]='White'
    colors[8]='N\A'
    colors[9]='N\A'

    # 4-Bit, 8 Colors by Color
    printf '\n4-Bit, 8 Colors by Color\n'
    printf '%6s|' ''
    # Print Set names
    for set in {0..9}; do
        printf '%10s|' "${sets[${set}]}"
    done
    printf '\n'
    printf '%6s|' ''
    # Print Set indexes
    for set in {0..9}; do
        printf '%10s|' ${set}
    done
    printf '\n'
    for color in $(seq 30 49; seq 90 109); do
        # Print Color name
        printf '%6s|' "${colors[${color} % 10]}"
        # Iterate through each Set and print each Color
        for set in {0..9}; do
            printf "\e[${set};${color}m%10s|\e[0m" ${color}
            # Print newline after each color
            if [ $(((${set} + 1) % 10)) == 0 ]; then
                printf '\n'
            fi
        done
    done

    # 4-Bit, 8 Colors by Set
    printf '\n4-Bit, 8 Colors by Set\n'
    printf '%10s|' ''
    # Print Color names twice
    for color in {0..19}; do
        printf '%6s|' "${colors[${color} % 10]}"
    done
    printf '\n'
    # Print Colors for each Set
    for set in {0..9}; do
        printf '%10s|' "${sets[${set}]}"
        for color in {30..49}; do  # Color codes
            printf "\e[${set};${color}m%6s|\e[0m" ${color}
            if [ $(((${color} - 29) % 20)) == 0 ]; then
                printf '\n'
            fi
        done
        printf '%10s|' "${sets[${set}]}"
        for color in {90..109}; do  # Color codes
            printf "\e[${set};${color}m%6s|\e[0m" ${color}
            if [ $(((${color} - 29) % 20)) == 0 ]; then
                printf '\n'
            fi
        done
    done
}

# Regular Colors
#Black='\e[0;30m'        # black
Black='\e[38;5;16m'     # black
Red='\e[0;31m'          # red
#Green='\e[0;32m'        # green
Green='\e[38;5;34m'        # green
#Yellow='\e[0;33m'       # yellow
Yellow='\e[38;5;228m'       # yellow
#Blue='\e[0;34m'         # blue
Blue='\e[38;5;27m'         # blue
#Purple='\e[0;35m'       # purple
Purple='\e[38;5;219m'       # purple
#Cyan='\e[0;36m'         # cyan
Cyan='\e[38;5;159m'         # cyan
#White='\e[0;37m'        # white
White='\e[38;5;255m'        # white

# Bold (1)
BBlack='\e[1;30m'       # black
BRed='\e[1;31m'         # red
BGreen='\e[1;32m'       # green
BYellow='\e[1;33m'      # yellow
BBlue='\e[1;34m'        # blue
BPurple='\e[1;35m'      # purple
BCyan='\e[1;36m'        # cyan
BWhite='\e[1;37m'       # white

# Underline (4)
UBlack='\e[4;30m'       # black
URed='\e[4;31m'         # red
UGreen='\e[4;32m'       # green
UYellow='\e[4;33m'      # yellow
UBlue='\e[4;34m'        # blue
UPurple='\e[4;35m'      # purple
UCyan='\e[4;36m'        # cyan
UWhite='\e[4;37m'       # white

# Background
#On_Black='\e[40m'       # black
On_Black='\e[48;5;16m'     # black
On_Red='\e[41m'         # red
#On_Green='\e[42m'       # green
On_Green='\e[48;5;34m'       # green
#On_Yellow='\e[43m'      # yellow
On_Yellow='\e[48;5;228m'      # yellow
#On_Yellow='\e[48;5;229m'      # yellow
#On_Blue='\e[44m'        # blue
On_Blue='\e[48;5;27m'        # blue
#On_Purple='\e[45m'      # purple
On_Purple='\e[48;5;219m'      # purple
#On_Cyan='\e[46m'        # cyan
On_Cyan='\e[48;5;159m'        # cyan
#On_White='\e[47m'       # white
On_White='\e[48;5;255m'       # white

# High Intensity
IBlack='\e[0;90m'       # black
IRed='\e[0;91m'         # red
IGreen='\e[0;92m'       # green
IYellow='\e[0;93m'      # yellow
IBlue='\e[0;94m'        # blue
IPurple='\e[0;95m'      # purple
ICyan='\e[0;96m'        # cyan
IWhite='\e[0;97m'       # white

# Bold High Intensity
BIBlack='\e[1;90m'      # black
BIRed='\e[1;91m'        # red
BIGreen='\e[1;92m'      # green
BIYellow='\e[1;93m'     # yellow
BIBlue='\e[1;94m'       # blue
BIPurple='\e[1;95m'     # purple
BICyan='\e[1;96m'       # cyan
BIWhite='\e[1;97m'      # white

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # black
On_IRed='\e[0;101m'     # red
On_IGreen='\e[0;102m'   # green
On_IYellow='\e[0;103m'  # yellow
On_IBlue='\e[0;104m'    # blue
On_IPurple='\e[0;105m'  # purple
On_ICyan='\e[0;106m'    # cyan
On_IWhite='\e[0;107m'   # white
