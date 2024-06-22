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
}

# Function to tap necessary repositories
tap_repositories() {
    brew tap homebrew/cask
    brew tap hashicorp/tap
}

# Function to uninstall all installed applications and casks
uninstall_all() {
    echo "Uninstalling all installed Homebrew apps and casks..."
    
    # Uninstall all apps
    installed_apps=$(brew list --formula)
    for app in $installed_apps; do
        echo "Uninstalling $app..."
        brew uninstall --force $app
    done
    
    # Uninstall all casks
    installed_casks=$(brew list --cask)
    for cask in $installed_casks; do
        echo "Uninstalling $cask..."
        brew uninstall --cask --force $cask
    done
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
tap_repositories
uninstall_all
install_apps
install_casks

echo "All specified applications and casks have been installed."
