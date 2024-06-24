#!/bin/bash

### List definitions ###

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
    ncdu
    pre-commit
    shellcheck
    tfenv
    tldr
    tmux
    tree
    wget
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

TAPS={ # Homebrew repositories to add
    homebrew/cask
    hashicorp/tap
    FelixKratz/formulae
}

### End of list definitions ###

install_rosetta() { # For x86 apps support
    if /usr/bin/pgrep oahd >/dev/null 2>&1; then
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    fi
}

install_homebrew() { # or skip if already installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew first."
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

# Function to tap necessary homebrew repositories
tap_homebrew_repositories() {
    for tap in "${TAPS[@]}"; do
        brew tap $tap
    done
}

# Function to install applications
install_homebrew_packages() {
    for package in "${PACKAGES[@]}"; do
        if ! brew list $package &> /dev/null; then
            echo "Installing $package..."
            brew install $package
        else
            echo "$package is already installed."
        fi
    done
}


install_homebrew_casks() { # Function to install casks
    for cask in "${CASKS[@]}"; do
        if ! brew list --cask $cask &> /dev/null; then
            echo "Installing $cask..."
            brew install --cask $cask
        else
            echo "$cask is already installed."
        fi
    done
}

install_oh_my_zsh() { # Function to install oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "oh-my-zsh is already installed."
    fi
}



# Main script execution
install_rosetta
install_homebrew
tap_homebrew_repositories
install_homebrew_packages
install_homebrew_casks
install_oh_my_zsh
