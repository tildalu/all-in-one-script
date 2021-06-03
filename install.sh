#!/usr/bin/env bash

# Text Color Variables
GREEN='\033[32m'  # Green
YELLOW='\033[33m' # YELLOW
CLEAR='\033[0m'   # Clear color and formatting

# Setup script for setting up a new macos machine
echo -e "${GREEN}Starting Install !${CLEAR}"

## Setup /etc/sudoers for sudo without password prompt
# echo -e "${GREEN}Setup NOPASSWD for %staff ${CLEAR}"
# sudo grep -q '^%staff' /etc/sudoers || sudo sed -i '' 's/^%admin.*/&\n%staff          ALL = (ALL) NOPASSWD: ALL/' /etc/sudoers

## Command Line Tools for Xcode
# echo "Install command line developer tools"
# xcode-select --install
# xcode-select -p &> /dev/null
# if [ $? -ne 0 ]; then
#   echo "Xcode CLI tools not found. Installing them..."
#   touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
#   PROD=$(softwareupdate -l |
#     grep "\*.*Command Line" |
#     head -n 1 | awk -F"*" '{print $2}' |
#     sed -e 's/^ *//' |
#     tr -d '\n')
#   softwareupdate -i "$PROD" -v;
# else
#   echo "Xcode CLI tools OK"
# fi

install-dev-tools() {

    ## Homebrew
    echo -e "${YELLOW}Install Homebrew${CLEAR}"
    CI=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    ## git
    echo -e "${YELLOW}Install GIT${CLEAR}"

    brew install git
    git config --global user.email "tilda.lu@trunk-studio.com"
    git config --global user.name "Tilda"

    ## Visual Studio Code
    echo -e "${YELLOW}Install Visual Studio Code${CLEAR}"
    brew install visual-studio-code

    ## mas-cli
    ## A simple command line interface for the Mac App Store. Designed for scripting and automation.
    echo -e "${YELLOW}Install mas-cli${CLEAR}"
    brew install mas

    ## VirtualBox
    echo -e "${YELLOW}Install Virtual Box ${CLEAR}"
    brew install virtualbox virtualbox-extension-pack

    # Docker, Vagrant
    echo -e "${YELLOW}Install Docker & Vagrant${CLEAR}"
    brew install docker vagrant

    #SourceTree
    echo -e "${YELLOW}Install SourceTree${CLEAR}"
    brew install --cask sourcetree

}

install-basic-tools() {

    ## Google Drive
    echo -e "${YELLOW}Install Google Drive${CLEAR}"
    brew install google-drive

    ## 1Password
    echo -e "${YELLOW}Install 1Password${CLEAR}"
    brew install 1password 1password-cli

    ## Zoom, Slack
    echo -e "${YELLOW}Install Zoom Slack${CLEAR}"
    brew install zoom slack

    ## Sketch, Figma
    echo -e "${YELLOW}Install Sketch Figma${CLEAR}"
    brew install sketch
    brew install figma

    # Line
    echo -e "${YELLOW}Install Line${CLEAR}"
    mas install 539883307

    # AnyDesk
    echo -e "${YELLOW}Install AnyDesk${CLEAR}"
    brew install anydesk
}

install-others() {
    echo -e "${YELLOW}Install Others${CLEAR}"
}

install-all() {
    install-dev-tools
    install-basic-tools
    install-others
}

install-all