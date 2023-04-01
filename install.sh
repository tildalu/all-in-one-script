#!/usr/bin/env bash

# Text Color Variables
GREEN='\033[32m'  # Green
YELLOW='\033[33m' # YELLOW
CLEAR='\033[0m'   # Clear color and formatting

# Setup script for setting up a new macos machine
echo -e "${GREEN}Starting Install !${CLEAR}"

install-dev-tools() {

    # Command Line Tools for Xcode
    echo "Install command line developer tools"
    xcode-select --install
    xcode-select -p &>/dev/null
    if [ $? -ne 0 ]; then
        echo "Xcode CLI tools not found. Installing them..."
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        PROD=$(softwareupdate -l |
            grep "\*.*Command Line" |
            head -n 1 | awk -F"*" '{print $2}' |
            sed -e 's/^ *//' |
            tr -d '\n')
        softwareupdate -i "$PROD" -v
    else
        echo "Xcode CLI tools OK"
    fi

    # Homebrew
    echo -e "${YELLOW}Install Homebrew${CLEAR}"
    CI=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew update

    # Visual Studio Code
    echo -e "${YELLOW}Install Visual Studio Code${CLEAR}"
    brew install visual-studio-code

    # mas-cli
    # A simple command line interface for the Mac App Store. Designed for scripting and automation.
    echo -e "${YELLOW}Install mas-cli${CLEAR}"
    brew install mas

    # VirtualBox
    echo -e "${YELLOW}Install Virtual Box ${CLEAR}"
    brew install virtualbox virtualbox-extension-pack

    # Docker, Vagrant
    echo -e "${YELLOW}Install Docker & Vagrant${CLEAR}"
    brew install vagrant
    brew install --cask docker

    # SourceTree
    echo -e "${YELLOW}Install SourceTree${CLEAR}"
    brew install --cask sourcetree

    # iTerm2
    echo -e "${YELLOW}Install iTerm2${CLEAR}"
    brew install iterm2

    # Appium
    echo -e "${YELLOW}Install Appium${CLEAR}"
    brew install appium

    # ngrok
    echo -e "${YELLOW}Install ngrok${CLEAR}"
    brew install ngrok

    # android-studio
    # echo -e "${YELLOW}Install android-studio${CLEAR}"
    # brew install --cask android-studio

    # android-platform-tools (for adb usings)
    # echo -e "${YELLOW}Install android-platform-tools${CLEAR}"
    # brew install homebrew/cask/android-platform-tools
}

install-dev-software() {
    # Python 3.x
    echo -e "${YELLOW}Install python-3.x${CLEAR}"
    brew install python

    # watchman
    echo -e "${YELLOW}Install watchman ${CLEAR}"
    brew install watchman

    # MongoDB
    echo -e "${YELLOW}Install MongoDB ${CLEAR}"
    brew tap mongodb/brew
    brew install mongodb-community@5.0

    # NVM
    echo -e "${YELLOW}Install NVM${CLEAR}"
    brew install nvm

    # nginx
    echo -e "${YELLOW}Install nginx${CLEAR}"
    brew install nginx

    # git
    echo -e "${YELLOW}Install GIT${CLEAR}"
    brew install git
    git config --global user.email "tilda.lu@trunk-studio.com"
    git config --global user.name "Tilda"

    # yarn
    echo -e "${YELLOW}Install yarn${CLEAR}"
    brew install yarn

    # pnpm
    echo -e "${YELLOW}Install pnpm${CLEAR}"
    brew install pnpm

    # hexo
    echo -e "${YELLOW}Install hexo${CLEAR}"
    npm install -g hexo-cli
    echo 'PATH="$PATH:./node_modules/.bin"' >>~/.profile

    # GNU Key
    echo -e "${YELLOW}Install GNU Key ${CLEAR}"
    brew install gnupg
    echo -e "${YELLOW}LIST GNU KEY${CLEAR}"
    gpg --list-secret-keys --keyid-format=long
}

install-basic-tools() {
    # Google Chrome
    # echo -e "${YELLOW}Install Google Chrome${CLEAR}"
    # brew install google-chrome

    # Brave
    echo -e "${YELLOW}Install Brave${CLEAR}"
    brew install --cask brave-browser

    # Google Drive
    echo -e "${YELLOW}Install Google Drive${CLEAR}"
    brew install google-drive

    # 1Password
    echo -e "${YELLOW}Install 1Password${CLEAR}"
    brew install 1password 1password-cli

    # Zoom, Slack
    echo -e "${YELLOW}Install Zoom Slack${CLEAR}"
    brew install zoom slack

    # Sketch, Figma
    echo -e "${YELLOW}Install Sketch Figma${CLEAR}"
    brew install sketch
    brew install figma

    # Zeplin
    echo -e "${YELLOW}Install zeplin ${CLEAR}"
    brew install zeplin

    # Line
    echo -e "${YELLOW}Install Line${CLEAR}"
    mas install 539883307

    # AnyDesk
    echo -e "${YELLOW}Install AnyDesk${CLEAR}"
    brew install anydesk

    # Notion
    echo -e "${YELLOW}Install Notion${CLEAR}"
    brew install notion
}

install-others() {
    # Skype
    # echo -e "${YELLOW}Install Skype ${CLEAR}"
    # brew install --cask skype

    # Spotify
    # echo -e "${YELLOW}Install Spotify${CLEAR}"
    # brew install spotify
}

check-by-doctor() {

    echo -e "${GREEN}Checking by Brew Doctor!${CLEAR}"
    brew doctor

}

powerlevel10k() {
    echo -e "${YELLOW}Powerlevel 10k!${CLEAR}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
}

php-laravel-packages() {

    # php
    echo -e "${YELLOW}Install php${CLEAR}"
    brew install php

    # install php@7.2
    # echo -e "${YELLOW}Install php@7.2${CLEAR}"
    # brew tap shivammathur/php
    # brew install shivammathur/php/php@7.2

    # link to php@7.2
    # echo -e "${YELLOW}Link to php@7.2${CLEAR}"
    # brew unlink php
    # brew link php@7.2

    # mysql
    echo -e "${YELLOW}Install mysql${CLEAR}"
    brew install mysql

    # start mysql
    echo -e "${YELLOW}Starting mysql${CLEAR}"
    brew services start mysql

    # composer
    echo -e "${YELLOW}Install composer${CLEAR}"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    # move to global use
    sudo mv composer.phar /usr/local/bin/composer

    # Laravel
    echo -e "${YELLOW}Install Laravel${CLEAR}"
    composer global require "laravel/installer"
}

install-all() {
    echo -e "${GREEN}Starting Install dev-tools !${CLEAR}"
    install-dev-tools

    echo -e "${GREEN}Starting install dev-software !${CLEAR}"
    install-dev-software

    echo -e "${GREEN}Starting Install basic-tools !${CLEAR}"
    install-basic-tools

    echo -e "${GREEN}Starting Install others !${CLEAR}"
    install-others

    echo -e "${GREEN}Starting Install php-laravel-packages !${CLEAR}"
    php-laravel-packages

    echo -e "${GREEN}Starting Install powerlevel10k!${CLEAR}"
    powerlevel10k

    echo -e "${GREEN}Starting Check !${CLEAR}"
    check-by-doctor

}

install-all
