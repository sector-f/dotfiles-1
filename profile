export XDG_CONFIG_HOME=~/.config/
export XDG_TEMPLATES_DIR=~/.local/share/templates/
export XKB_DEFAULT_LAYOUT=ja

export DEVKITPRO=~/devkitpro
export DEVKITARM=$DEVKITPRO/devkitARM
export DEVKITPPC=$DEVKITPRO/devkitPPC

export PATH=$PATH:$DEVKITARM/bin
export TONCCODE=$DEVKITPRO/tonc

export PATH=$HOME/.gem/ruby/2.1.0/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

export NPM_PACKAGES=/home/jaume/.npm-packages
export NODE_PATH=/home/jaume/.npm-packages/lib/node_modules:
export PATH=$NPM_PACKAGES/bin:$PATH

PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

export ANDROID_NDK_PATH=/opt/android-ndk

export JPM_FIREFOX_BINARY=/usr/bin/firefox

export TERMINAL="mate-terminal"
export EDITOR="nvim"
export VISUAL="nvim"
export WINEDLLOVERRIDES="winemenubuilder.exe=d"
export WINEARCH="win32"
export BROWSER="firefox"
#export QT_STYLE_OVERRIDE="breeze"

#export WINEPREFIX="$HOME/.wine"

export BSPWM_TREE=/tmp/bspwm.tree
export BSPWM_HISTORY=/tmp/bspwm.history
export BSPWM_STACK=/tmp/bspwm.stack
export PANEL_FIFO=/tmp/panel_fifo
export XDG_MUSIC_DIR=~/music

export WEECHAT_HOME="$XDG_CONFIG_HOME"/weechat

export GOPATH=~/coses/go
export PATH=$GOPATH/bin:$PATH

export CHICKEN_REPOSITORY=~/.local/lib/chicken/8

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0
export LD_LIBRARY_PATH=$HOME/.local/lib:/usr/local/lib:$LD_LIBRARY_PATH
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export PATH=~/.rakudobrew/bin:$PATH

export MAKEFLAGS=-j5

export STEAM_RUNTIME=0

export EMU="-r$HOME/coses/inferno-os -c0 -g1024x768"
