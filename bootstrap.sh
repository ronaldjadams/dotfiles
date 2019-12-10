#!/usr/bin/env bash
# Provision a new Apple OS X machine
# Author Ron. A @0xADADA

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function sync() {
  rsync --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude ".macos" \
    --exclude "bootstrap.sh" \
    --exclude "brew.sh" \
    --exclude "README.md" \
    --exclude "LICENSE" \
    -av --no-perms . ~
  # add SSH key to macOS keychain
  echo "⚠️  Adding SSH key to macOS Keychain⚠️  "
  ssh-add -K ~/.ssh/id_rsa
}

# Homebrew OS X package manager
function install_homebrew() {
  echo "Installing Homebrew kegs and casks..."
  source brew.sh
}

function install_asdf() {
  # Setup asdf (installed via homebrew)
  source /usr/local/opt/asdf/asdf.sh
  asdf update
  asdf plugin-add elixir
  asdf plugin-add erlang
  asdf plugin-add python
  asdf plugin-add nodejs
  asdf plugin-add ruby
  asdf plugin-update --all
  # install latest 8-branch Nodejs, set it globally
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
  asdf install nodejs $(asdf list-all nodejs | grep '^\b[0-9]*[02468]\b' | tail -n 1)
  asdf global nodejs $(asdf list nodejs | tail -n 1)
  # install latest erlang, set it globally
  asdf install erlang $(asdf list-all erlang | grep -E '^(\d+).(\d+).(\d+)$' | tail -n 1)
  asdf global erlang $(asdf list erlang | tail -n 1)
  # install latest elixir, set it globally
  asdf install elixir $(asdf list-all elixir | grep -E '^(\d+).(\d+).(\d+)$' | tail -n 1)
  asdf global elixir $(asdf list elixir | tail -n 1)
  # install latest python2
  asdf install python $(asdf list-all python | grep -E '^2.(\d+).(\d+)$' | tail -n 1)
  # install latest python3, set it globally
  LDFLAGS="-L$(brew --prefix openssl)/lib" \
  CPPFLAGS="-I$(brew --prefix openssl)/include" \
  CFLAGS="-I$(brew --prefix openssl)/include" \
  asdf install python $(asdf list-all python | grep -E '^3.(\d+).(\d+)$' | tail -n 1)
  asdf global python $(asdf list python | tail -n 1)
  # install latest ruby, set it globally
  asdf install ruby $(asdf list-all ruby | grep -E '^(\d+).(\d+).(\d+)$' | tail -n 1)
  asdf global ruby $(asdf list ruby | tail -n 1)
}

# Bootstrap provisioning for all OSes
function provision_universal() {
  read -p "Install asdf, Continue (y/n)? " choice
  case "$choice" in
    y|Y ) install_asdf;;
    n|N ) echo "Skipping asdf";;
    * ) echo "invalid answer";;
  esac

  echo "Installing Yarn packages"
  yarn global add tldr
}

# Bootstrap provisioning for vim
function provision_vim() {
  echo "Installing VIM packages"
  # finalize Neovim
  rm -rf ~/.vim*
  ln -s ~/.config/nvim ~/.vim
  ln -s ~/.config/nvim/init.vim ~/.vimrc
  echo ""

  # install neovim language deps
  yarn global add neovim
  gem install neovim
  pip3 install pynvim  #install dependency for Denite

  # install vim-plug
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    echo "installed vim-plug"
  nvim -c ":PlugInstall" -c ":qall" && echo "installed all vim plugins"

  # install coc.nvim language servers
  nvim -c ":CocInstall coc-tsserver coc-eslint coc-prettier coc-html coc-css coc-json coc-python coc-yaml" \
    -c ":qall" && \
    echo " installed coc.nvim language servers"
}

# Bootstrap provisioning for OS X
function provision_darwin() {
  # Install XCcode command line tools
  echo "Installing XCode command line tools..."
  xcode-select --install

  # Remove garageband
  pkgutil --forget com.apple.pkg.GarageBand_AppStore
  pkgutil --forget com.apple.pkg.GarageBandBasicContent
  sudo rm -rfv /Applications/GarageBand.app && \
    rm -rfv /Library/Application\ Support/GarageBand && \
    rm -rfv /Library/Application\ Support/Logic/ && \
    rm -rfv /Library/Audio/Apple\ Loops && \
    rm -rfv /Library/Audio/Apple\ Loops\ Index && \
    rm -rfv /Library/Receipts/com.apple.pkg.*GarageBand* && \
    rm -rfv ~/Library/Audio/Apple Loops && \
    rm -rfv ~/Library/Application\ Support/GarageBand

  # call homebrew and homebrew cask scripts (installs NPM, etc)
  read -p "Install Homebrew and all packages (y/n)? " choice
  case "$choice" in
    y|Y ) install_homebrew;;
    n|N ) echo "Skipping homebrew";;
    * ) echo "invalid answer";;
  esac

  # Setup OS X system defaults
  read -p "Setup OS X system defaults (y/n)? " choice
  case "$choice" in
    y|Y ) source .macos;;
    n|N ) echo "Skipping OS X defaults";;
    * ) echo "invalid answer";;
  esac
}

function install_linux() {
  # Stuff to install after installing linux
  sudo pacman -Sy

  echo "General utilities"
  sudo pacman -S tree \
         rsync \
         which \
         dialog \
         wpa_supplicant \
         yarn

  echo "Power utilities"
  sudo pacman -S cpupower \
         powertop \
         acpi \
         acpid
  yaourt -S    laptop-mode-tools \
         mbpfan-git \
         thermald
}

function provision_linux() {
  # we're in linux
  echo "Updating pacman database"
  sudo pacman -Sy

  echo "Actually installing shit..."
  # some base utils
  sudo pacman -S openssh \
         keybase \
         git \
         vim \
         bluez \
         bluez-utils

  # Install X
  sudo pacman -S xf86-video-intel \
         xf86-input-synaptics \
         xorg-server \
         xorg-init \
         rxvt-unicode

  # Install X utilities and apps
  yaourt -S awesome \
    vicious \
    xbindkeys \
    xautolock \
    xorg-xsetroot \
    slock \
    lain-git  # Layouts n shit, yo

  # install some great fonts
  yaourt -S noto-fonts-emoji \
    terminus-font \
    adobe-source-sans-pro-fonts \
    adobe-source-serif-pro-fonts \
    adobe-source-code-pro-fonts \
    otf-sauce-code-powerline-git \  # Adobe Source Code Pro (Patched for Powerline)
    ttf-twitter-color-emoji-svginot # Twitter Emoji for Everyone

  # install keyboard / IME tools
  yaourt -S ibus \
    ibus-uniemoji-git

  # Install monitor calibration tools
  yaourt -S xcalib \
    xflux \
    xfluxd \
    kbdlight

  # Install some useful applications
  yaourt -S rslsync \
    nvm-git \
    pyenv \
    firefox-beta-bin \
    google-chrome \
    google-earth \
    mpv \
    mysql-workbench \
    spotify \
    android-tools \
    bitcoin-qt \
    transmission-gtk
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  sync;
else
 read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
 echo "";
 if [[ $REPLY =~ ^[Yy]$ ]]; then
   sync;
 fi;
fi;

# Provision OS X applications
if [[ $OSTYPE == darwin* ]]; then
  read -p "Provision OS X software? (y/n)? " choice
  case "$choice" in
    y|Y ) provision_darwin;;
    n|N ) echo "Skiping OS X provisioning";;
    * ) echo "invalid answer";;
  esac
fi

# Provision GNU/Linux applications
if [[ $OSTYPE == linux* ]]; then
  read -p "Provision Linux software? (y/n)? " choice
  case "$choice" in
    y|Y ) provision_linux;;
    n|N ) echo "Skiping Linux provisioning";;
    * ) echo "invalid answer";;
  esac
fi
# Provision any vim specific deps
read -p "Provision vim? (y/n)? " choice
case "$choice" in
  y|Y ) provision_vim;;
  n|N ) echo "Skiping provisioning";;
  * ) echo "invalid answer";;
esac

# Provision any OS-non specific applications
read -p "Provision non-specific OS software? (y/n)? " choice
case "$choice" in
  y|Y ) provision_universal;;
  n|N ) echo "Skiping provisioning";;
  * ) echo "invalid answer";;
esac

# cleanup
unset sync;
unset install_homebrew;
unset install_asdf;
unset provision_universal;
unset provision_vim;
unset provision_darwin;
unset provision_linux;

# finish up
echo
echo "System has been bootstrapped."
echo "You probably should restart."
