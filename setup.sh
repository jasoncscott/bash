#! /bin/bash

# Determine repo location
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Set ${DOTFILES_LOC} to repo location (f repo is in home directory, use `${HOME}`)
cd "${SCRIPT_DIR}"
sed --in-place "/export DOTFILES/c\export DOTFILES_LOC=\"${SCRIPT_DIR}/\"" .bashrc
sed --in-place "s|${HOME}|\$\{HOME\}|" .bashrc

# Symlink bash files to repo (use relative links if repo is in home directory)
cd "${HOME}"
ln -sfn "${SCRIPT_DIR//${HOME}\//}/.bash_logout"
ln -sfn "${SCRIPT_DIR//${HOME}\//}/.bash_profile"
ln -sfn "${SCRIPT_DIR//${HOME}\//}/.bashrc"

# Symlink Microsort App Installer (`winget`) settings
# TODO: Don't stomp on existing settings (add a flag or just backup file)
MS_WINGET_DIR="${LOCALAPPDATA}/Packages/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe/"
if [[ -d "${MS_WINGET_DIR}" ]]; then
    cd "${MS_WINGET_DIR}/LocalState"
    ln -sfn "${SCRIPT_DIR}/microsoft-winget-appinstaller/settings.json"
fi

# Symlink Microsoft Terminal settings
# TODO: Don't stomp on existing settings (add a flag or just backup file)
MS_TERMINAL_DIR="${LOCALAPPDATA}/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/"
if [[ -d "${MS_TERMINAL_DIR}" ]]; then
    cd "${MS_TERMINAL_DIR}/LocalState/"
    ln -sfn "${SCRIPT_DIR}/microsoft-terminal/settings.json"
fi

