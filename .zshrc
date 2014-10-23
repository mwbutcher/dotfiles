# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
#export ZSH_THEME="prose"
export ZSH_THEME="demophoon"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Completion settings
zstyle ':completion:*' completer _complete
zstyle ':completion:*' menu select=20
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*:approximate:*' max-errors 2
zstyle ':completion:*:commands' rehash 1
zstyle ':completion:*:warnings' format 'Nothing to do here'
autoload -Uz compinit
compinit

# Common things
[[ -s "$HOME/.commonrc" ]] && source "$HOME/.commonrc"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(osx git ruby gem node npm heroku cap bundler brew cake rails3 redis-cli zsh-syntax-highlighting)
plugins=(osx ssh-agent git ruby rbenv gem bundler brew zsh-syntax-highlighting python)

source $ZSH/oh-my-zsh.sh

# Enable vi like editing at the command line
bindkey -v
