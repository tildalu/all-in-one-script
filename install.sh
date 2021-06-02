#!/usr/bin/env bash

# Text Color Variables
GREEN='\033[32m' # Green
CLEAR='\033[0m'  # Clear color and formatting



# Setup script for setting up a new macos machine
echo -e "${GREEN}Starting Install !${CLEAR}"

## Setup /etc/sudoers for sudo without password prompt
echo -e "${GREEN}Setup NOPASSWD for %staff ${CLEAR}"
sudo grep -q '^%staff' /etc/sudoers || sudo sed -i '' 's/^%admin.*/&\n%staff          ALL = (ALL) NOPASSWD: ALL/' /etc/sudoers

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




install-dev-tools(){

    ## Homebrew
    echo "Install Homebrew"
    CI=1; /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    ## git
    brew install git
    git config --global user.email "tilda.lu@trunk-studio.com"
    git config --global user.name "Tilda"

    ## Visual Studio Code
    brew install visual-studio-code

    ## mas-cli
    ## A simple command line interface for the Mac App Store. Designed for scripting and automation.
    brew install mas


    ## VirtualBox
    brew install virtualbox virtualbox-extension-pack

    # Docker, Vagrant
    brew install docker vagrant

}
install-basic-tools(){

    ## 1Password
    brew install 1password 1password-cli


    ## Zoom, Slack
    brew install zoom slack

    ## Sketch, Figma
    brew install sketch 
    brew install --cask figma

    # Line
    mas install 539883307


}


install-all(){
    install-dev-tools
    install-basic-tools
    install-others
}

install-all