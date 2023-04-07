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
    #echo -e "${YELLOW}Install MongoDB ${CLEAR}"
    #brew tap mongodb/brew
    #brew install mongodb-community@5.0

    # NVM
    echo -e "${YELLOW}Install NVM${CLEAR}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

    source ~/.nvm/nvm.sh

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
    # echo -e "${YELLOW}Install hexo${CLEAR}"
    # npm install -g hexo-cli
    # echo 'PATH="$PATH:./node_modules/.bin"' >>~/.profile

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

config-gpg() {
    echo -e "${YELLOW}Install GnuPG${CLEAR}"
    brew install gnupg

    echo -e "${YELLOW}Install Pinentry${CLEAR}"
    brew install pinentry-mac

    echo -e "${YELLOW}Config Pinentry${CLEAR}"
    echo "pinentry-program $(which pinentry-mac)" >>~/.gnupg/gpg-agent.conf
    gpgconf --kill gpg-agent

    echo -e "${YELLOW}Setup GPG Sign${CLEAR}"
    if [ -f "private-key.gpg" ]; then
        echo -e "${YELLOW}GPG file exists!${CLEAR}"

        echo -e "${YELLOW}Import GPG key${CLEAR}"
        gpg --import private-key.gpg

        keyid=$(gpg --quiet --import-options import-show --import private-key.gpg | sed -e '2!d' -e 's/^[ \t]*//')

        echo -e "${YELLOW}Change trust level${CLEAR}"
        echo "${keyid}:6:" | gpg --import-ownertrust

        echo -e "${YELLOW}Test gpg signing${CLEAR}"
        echo "test" | gpg --clearsign

        echo -e "${YELLOW}Enable git signing${CLEAR}"
        git config --global user.signingkey "${keyid}"
        git config --global commit.gpgsign true
    else
        echo -e "${YELLOW}GPG file not exist, GPG setup skipped!${CLEAR}"
    fi
}

setup-zsh() {
    echo -e "${YELLOW}Install oh-my-zsh${CLEAR}"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo -e "${YELLOW}Set Z-Shell to default shell${CLEAR}"
    sudo chsh -s $(which zsh) $(whoami)

    echo -e "${YELLOW}Setup oh-my-zsh${CLEAR}"

    echo -e "${YELLOW}Install theme powerlevel10k${CLEAR}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i '' 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/' ~/.zshrc

    echo -e "${YELLOW}Install plugin zsh-completions${CLEAR}"
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    sed -i '' 's/source $ZSH\/oh-my-zsh.sh/fpath\+=\${ZSH_CUSTOM\:-\${ZSH\:-~\/.oh-my-zsh}\/custom}\/plugins\/zsh-completions\/src\nZSH_DISABLE_COMPFIX=\"true\"\nsource $ZSH\/oh-my-zsh.sh/' ~/.zshrc

    echo -e "${YELLOW}Install plugin zsh-syntax-highlighting${CLEAR}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    sed -i '' 's/plugins=(git/plugins=(git zsh-syntax-highlighting/' ~/.zshrc

    echo -e "${YELLOW}Install default plugins for python and docker${CLEAR}"
    sed -i '' 's/plugins=(git/plugins=(git python pip docker docker-compose/' ~/.zshrc
}

install-node() {
    echo -e "${YELLOW}Install nvm${CLEAR}"
    export NVM_DIR="$HOME/.nvm" && (
        git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
        cd "$NVM_DIR"
        git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
    ) && \. "$NVM_DIR/nvm.sh"

    echo -e "${YELLOW}Install latest lts version${CLEAR}"
    nvm install --lts

    echo -e "${YELLOW}Enable corepack for yarn and pnpm${CLEAR}"
    corepack enable

    echo -e "${YELLOW}Add nvm config to zshrc${CLEAR}"
    echo "export NVM_DIR=\"\$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\"" >>~/.zshrc
    echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\" # This loads nvm" >>~/.zshrc
    echo "" >>~/.zshrc

    echo -e "${YELLOW}Install default node npm nvm yarn plugin for oh-my-zsh${CLEAR}"
    sed -i '' 's/plugins=(git/plugins=(git node npm nvm yarn/' ~/.zshrc
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

    # mysql
    echo -e "${YELLOW}Install mysql${CLEAR}"
    brew install mysql

    # start mysql
    echo -e "${YELLOW}Starting mysql${CLEAR}"
    brew services start mysql

    # composer
    echo -e "${YELLOW}Install composer${CLEAR}"
    brew install composer
    # move to global use
    sudo mv composer.phar /usr/local/bin/composer

    # Laravel
    echo -e "${YELLOW}Install Laravel${CLEAR}"
    composer global require "laravel/installer"

    echo -e "${YELLOW}Install default composer and laraval plugin for oh-my-zsh${CLEAR}"
    sed -i '' 's/plugins=(git/plugins=(git composer laravel laravel5/' ~/.zshrc
}

install-all() {
    echo -e "${GREEN}Starting Install dev-tools !${CLEAR}"
    install-dev-tools

    echo -e "${GREEN}Starting install dev-software !${CLEAR}"
    install-dev-software

    echo -e "${GREEN}Setup basic config${CLEAR}"
    config-gpg

    echo -e "${GREEN}Setup Z-Shell${CLEAR}"
    setup-zsh

    echo -e "${GREEN}Install Node.js${CLEAR}"
    install-node

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
