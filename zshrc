# Command history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS    # Don't save duplicates to history
setopt HIST_IGNORE_SPACE   # Don't save entries starting with space


# Enable writing `my/dir/subdir` instead of `cd my/dir/subdir`
setopt autocd

# Don't. Ever. Beep. At. Me.
unsetopt beep

# Use vi mode
bindkey -v
bindkey -v '^?' backward-delete-char


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
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Environment
export VISUAL=nvim
export EDITOR=$VISUAL
export TERMINAL=alacritty
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"

# Aliases
alias cd..='cd ..'
alias grep='grep --color=auto'
alias l='ls'
alias ls='ls -1 --color=auto'
alias lsl='ls -l --color=auto'
alias o='okular'
alias v='nvim'
alias vim='nvim'
alias vimr='vim -R'
alias gts='git status'
alias gta='git add'
alias gtp='git push'
alias gtc='git commit'

# Path
# export PATH="$HOME/.node_modules_global/bin:$PATH"
export PATH="$PATH:$GEM_HOME/bin:$HOME/.bin"
