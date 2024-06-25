#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'  # Green color
NC='\033[0m'        # No color

############################

### List definitions ###

TAPS=( # Homebrew repositories to add, if neccesary for some apps
    hashicorp/tap
    FelixKratz/formulae
)

CASKS=( # List of desktop apps, or brew casks, to install
    1password
    1password-cli
    anydesk
    balenaetcher
    calibre
    coteditor
    devtoys
    discord
    hiddenbar
    maccy
    monitorcontrol
    netnewswire
    onlyoffice
    onyx
    opera
    podman-desktop
    qbittorrent
    raycast
    rectangle
    simple-comic
    spotify
    stats
    steam
    visual-studio-code
    vlc
    zoom
    zed
)

PACKAGES=( ### list of homebrew package formulae, or brew leaves, to install
    docker
    fastfetch
    fzf
    git
    glib
    go
    guile
    helm
    htop
    jq
    kubernetes-cli
    mas # Required to install App Store free apps
    ncdu
    pre-commit
    shellcheck
    tfenv
    tldr
    tmux
    tree
    wget
)

APPLE_STORE_APPS=( ### list of homebrew package formulae, or brew leaves, to install
    Hologram Desktop
)

### End of list definitions ###

#####################################

### Start of function definitions ###

set_hostname() {
    # Prompts you for a MacBook name change
    while true; do
        echo -e "Do you want to set the hostname (You will be prompted for your password if you confirm)? (y/n): " 
        read RESPONSE
        RESPONSE=$(echo "$RESPONSE" | tr '[:upper:]' '[:lower:]')
        case "$RESPONSE" in
            y|yes)
                echo -e "Enter the desired name for your MacBook:" 
                read NEW_HOSTNAME
                echo -e "Changing mac name to $NEW_HOSTNAME. Password (sudoer) is required" 
                sudo -v
                sudo scutil --set ComputerName "$NEW_HOSTNAME"
                sudo scutil --set HostName "$NEW_HOSTNAME"
                sudo scutil --set LocalHostName "$NEW_HOSTNAME"
                echo "Done"
                break
                ;;
            n|no)
                echo "Hostname change aborted. Proceeding to next step..."
                break
                ;;
            *)
                echo "Please answer y or n."
                ;;
        esac
    done
}

install_rosetta() { # For x86 apps support
    if /usr/bin/pgrep oahd >/dev/null 2>&1; then
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    fi
}

install_homebrew() { # or skip if already installed
    if ! command -v brew &> /dev/null; then
        printf "${GREEN}Homebrew not found. Installing Homebrew first.${NC}\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew found."
    fi

    # Add Homebrew to PATH
    export PATH=$PATH:/opt/homebrew/bin

    # Add Homebrew to .zshrc
    if ! grep -qx 'export PATH=$PATH:/opt/homebrew/bin' ~/.zshrc; then
        echo 'export PATH=$PATH:/opt/homebrew/bin' >> ~/.zshrc
        echo "Added Homebrew to PATH in .zshrc"
    else
        echo "Homebrew already in PATH in .zshrc"
    fi
}

tap_homebrew_repositories() { # based on the list of taps provided
    for tap in "${TAPS[@]}"; do
        printf "${GREEN}Adding Homebrew tap $tap...${NC}\n"
        brew tap "$tap"
    done
}

install_homebrew_casks() { # based on the list of casks provided
    for cask in "${CASKS[@]}"; do
        if ! brew list --cask "$cask" &> /dev/null; then
            printf "${GREEN}Installing $cask...${NC}\n"
            brew install --cask "$cask"
        else
            echo "$cask is already installed."
        fi
    done
}

install_homebrew_packages() { # based on the list of packages provided
    for package in "${PACKAGES[@]}"; do
        if ! brew list "$package" &> /dev/null; then
            printf "${GREEN}Installing $package...${NC}\n"
            brew install "$package"
        else
            echo "$package is already installed."
        fi
    done
}

install_app_store_apps() { # Requires mas-cli to be installed (pre-included in the - see https://github.com/mas-cli/mas
# Note: Only works with free apps
    for app_store_app in "${APPLE_STORE_APPS[@]}"; do
        printf "${GREEN}Installing $app_store_app...${NC}\n"
        mas lucky "$app"
    done
}

install_oh_my_zsh() { # Note: Automatically reopens the shell, cleaning all history
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        printf "${GREEN}Installing oh-my-zsh...${NC}\n"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "oh-my-zsh is already installed."
    fi
}

### End of function definitions ###

###################################

#### Main script execution ####
printf "${GREEN}Welcome to the 'Macgyver' install script!${NC}\n"
set_hostname
install_rosetta
install_homebrew
tap_homebrew_repositories
install_homebrew_casks
install_homebrew_packages
install_app_store_apps
install_oh_my_zsh
#### End of main script execution ####

###################################
