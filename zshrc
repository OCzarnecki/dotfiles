# Command history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS    # Don't save duplicates to history
setopt HIST_IGNORE_SPACE   # Don't save entries starting with space


# Enable writing `my/dir/subdir` instead of `cd my/dir/subdir`
setopt autocd

# Don't. Ever. Beep. At. Me.
unsetopt beep

# Use vi mode
bindkey -v
bindkey -v '^?' backward-delete-char
bindkey jk vi-cmd-mode
bindkey kj vi-cmd-mode


# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle :compinstall filename '/home/olaf/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Theme
autoload -Uz compinit promptinit
compinit
promptinit
prompt walters

# If the last output line didn't end with a new line, don't overwrite it
# (must be set after theme)
setopt nopromptcr

# Fuzzy Search
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
# if [ -f /usr/share/fzf/key-bindings.zsh ] ; then
# 	source /usr/share/fzf/key-bindings.zsh
# 	source /usr/share/fzf/completion.zsh
# fi

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
source <(fnm env)

# ssh agent
if ! pgrep -u "$USER" ssh-agent > /dev/null && [ -f $XDG_RUNTIME_DIR/ssh-agent.env ]; then
  ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "SSH_AUTH_SOCK" ]]; then
  source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# Environment
export VISUAL=nvim
export EDITOR=$VISUAL
export TERMINAL=alacritty
# export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"

# Aliases
alias cd..='cd ..'
alias grep='grep --color=auto'
alias l='ls'
alias ls='ls -1 --color=auto'
alias lsl='ls -l --color=auto'
alias o='zathura'
alias v='nvim'
alias vim='nvim'
alias vimr='vim -R'
alias gts='git status'
alias gta='git add'
alias gtp='git push'
alias gtc='git commit'
alias gtl='git log'
alias gtd='git diff'
alias fd.='fd .'

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.bin/scripts"
export PATH="$PATH:$HOME/.gem/ruby/3.3.0/bin/"
export PATH="$PATH:$HOME/.rbenv/shims/"
export PATH="$PATH:$HOME/dev/scripts"

function ez {
    (
        cd "$HOME/develop/dotfiles"
        "$EDITOR" "./zshrc"
        echo -n "Commit msg [empty for no commit]: zshrc: "
        read msg
        if [ -n "$msg" ]; then
            git add ./zshrc
            git commit -m "zshrc: $msg"
        else
            echo "Skipping commit. There may be uncommitted changes in your dotfiles!"
        fi
    )
    source "$HOME/.zshrc"
}

function ac {
    source ./.venv/bin/activate
}

function newdraft {
    if [ $# -ne 1 ] ; then
        echo "Usage: newdraft NAME-OF-POST"
        return 1
    fi
    cd "$HOME/develop/pgwm/thedissonance.net/"
    fname="./_drafts/$1.md"
    echo "---
title:
layout: post
date: $(date -Idate)
---

""" > $fname
    $EDITOR $fname
}

function gtcp {
    git commit "${@}" || return 1
    git push
}

function watchpy {
    fd --glob "*.{py,yaml,yml}" | entr "${@}"
}

function dc {
    deactivate
}

function gtnb {
    git fetch
    git checkout origin/main
    git switch -c "olaf/$1"
}

function grom {
    echo "Warning! Use gmom, non grom!"
    git fetch
    git merge origin/main
}

function gmom {
    git fetch
    git merge origin/main
}

function fixlock {
    git checkout HEAD -- pnpm-lock.yaml
    pnpm install
    git add pnpm-lock.yaml
}

# pnpm
export PNPM_HOME="/Users/olaf/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Meticulous
export PATH="$HOME/.local/bin:$PATH"
export METICULOUS_API_URL=http://webapp-backend-production-meticulous-webapp-backend-admin:3000/api
export METICULOUS_REPO_PATH=$HOME/dev/meticulous
source "$HOME/dev/meticulous/scripts/shell.sh"
