[ -z "$PS1" ] && return

set -o vi
bind -m vi-insert "\C-l":clear-screen

bind TAB:menu-complete
export EDITOR="vim"
export PYTHONSTARTUP="$(dirname `readlink ~/.bashrc`)/.pythonrc"

if [ -e "/usr/local/bin/virtualenvwrapper.sh" ]; then
    export WORKON_HOME=$HOME/.virtualenvs/
    export PROJECT_HOME=$HOME/Devel/
    source /usr/local/bin/virtualenvwrapper.sh
fi

# @gf3’s Sexy Bash Prompt, inspired by “Extravagant Zsh Prompt”
# Shamelessly copied from https://github.com/gf3/dotfiles
# Screenshot: http://i.imgur.com/s0Blh.png

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        MAGENTA=$(tput setaf 9)
        ORANGE=$(tput setaf 172)
        GREEN=$(tput setaf 190)
        PURPLE=$(tput setaf 141)
        WHITE=$(tput setaf 0)
    else
        MAGENTA=$(tput setaf 5)
        ORANGE=$(tput setaf 4)
        GREEN=$(tput setaf 2)
        PURPLE=$(tput setaf 1)
        WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

export MAGENTA
export ORANGE
export GREEN
export PURPLE
export WHITE
export BOLD
export RESET

function parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}

function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# zshell stuff
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
        hg root >/dev/null 2>/dev/null && echo '☿' && return
        echo '○'
}

function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
        < on %{$fg[magenta]%}<branch>%{$reset_color%}>\
        < at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
        %{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
        patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

    PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
    $(virtualenv_info)$(prompt_char) '

    RPROMPT='$(battery_charge)'

    ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
    ZSH_THEME_GIT_PROMPT_CLEAN=""
# Here be dragons

if [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
    export PS1="\[${BOLD}${MAGENTA}\]\u \[$WHITE\]at \[$ORANGE\]\h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n\$ \[$RESET\]"
    export PS2="\[$ORANGE\]→ \[$RESET\]"
fi

dotfiles=$( dirname `readlink ~/.bashrc` )
dotfilesupdate=". $dotfiles/update.sh"

PATH=$PATH:$dotfiles/utils
if [ -d "$HOME/.rbenv/bin" ]; then
    PATH=$HOME/.rbenv/bin:$PATH
fi
$dotfilesupdate
export DISPLAY=:0

# Git fetch pull requests from upstream

fetchpr () {
  pr_num=$1
  git fetch puppetlabs "refs/pull/${pr_num}/head"
  git checkout -b "pull-${pr_num}" FETCH_HEAD
}

# Git autocomplete
source ~/.git-completion.sh

source $HOME/.commonrc

if [ -e "$HOME/.bashrc.local" ]; then
    source $HOME/.bashrc.local
fi
