#!/bin/bash

# Variables for apps and casks
APPS=(
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

CASKS=(
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
)

# Function to check if Homebrew is installed
check_brew() {
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

# Function to install oh-my-zsh
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "oh-my-zsh is already installed."
    fi
}

# Function to tap necessary repositories
tap_repositories() {
    brew tap homebrew/cask
    brew tap hashicorp/tap
}

# Function to install applications
install_apps() {
    for app in "${APPS[@]}"; do
        if ! brew list $app &> /dev/null; then
            echo "Installing $app..."
            brew install $app
        else
            echo "$app is already installed."
        fi
    done
}

# Function to install casks
install_casks() {
    for cask in "${CASKS[@]}"; do
        if ! brew list --cask $cask &> /dev/null; then
            echo "Installing $cask..."
            brew install --cask $cask
        else
            echo "$cask is already installed."
        fi
    done
}

# Main script execution
check_brew
install_oh_my_zsh
tap_repositories
install_apps
install_casks

echo "All specified applications and casks have been installed."
