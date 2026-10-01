#!/usr/bin/env zsh
 
# add local dirs to relevant PATHs
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/sbin:$PATH"

# zsh command history
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY # timestamps in history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE # lines starting with space aren't recorded (should be default lol)
setopt HIST_VERIFY
setopt SHARE_HISTORY # share across all open sessions
setopt INC_APPEND_HISTORY

# zsh sugar
setopt AUTO_CD # type a dir name to cd into it
setopt AUTO_PUSHD # cd pushes old dir onto stack
setopt PUSHD_IGNORE_DUPS
setopt CORRECT # command auto-correction, sometimes annoying but usually helpful
setopt INTERACTIVE_COMMENTS   # allow # comments in interactive shell
unsetopt BEEP # no beep beep

# completions
autoload -Uz compinit
# only regenerate the completion dump once a day (much faster startup)
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true

# pluhgins management
_src() { [[ -r $1 ]] && source "$1" }
_src /usr/share/zsh/plugins/fzf-tab-git/fzf-tab.plugin.zsh
_src /usr/share/zsh/plugins/zsh-autopair/autopair.zsh
_src /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
_src /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
_src /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# starship
if command -v starship &> /dev/null; then
   # let people use their own starship.toml or else use the default one
   [[ -f ~/.config/starship.toml ]] || export STARSHIP_CONFIG=/etc/starship.toml
    eval "$(starship init zsh)"
else
    echo "starship not found... mumma..."
fi

# smarter cd just because
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi

# fuzzy finder (written in Go for some fucking reason)
# sorry chuds but you're getting GC spikes in your terminal
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)" 2>/dev/null || {
        [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && \
            source /usr/share/doc/fzf/examples/key-bindings.zsh
        [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && \
            source /usr/share/doc/fzf/examples/completion.zsh
    }
    export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border --preview-window=right:60%"
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
    # use bat to preview files if available
    if command -v bat &> /dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :300 {}'"
    fi
fi

# eza: what is ls was BRAHMIN 
if command -v eza &> /dev/null; then
    # some common ls aliases 
    alias ls='eza --icons --group-directories-first --git'
    alias l='eza -lah --icons --group-directories-first --git' # most people just use that          
    alias ll='eza -lh --icons --group-directories-first --git'         
    alias la='eza -lah --icons --group-directories-first --git --no-permissions --no-user --no-time'
    alias lt='eza --tree --level=2 --icons --group-directories-first'   
    alias lta='eza --tree --level=3 --icons -a --group-directories-first'
else
    alias ls='ls --color=auto'
    echo "eza not found... mumma..."
fi

# bat gives syntax highlighting to cat
if command -v bat &> /dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias catn='bat --paging=never'             
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export BAT_THEME="Catppuccin Mocha"
else
    echo "bat not found... mumma..."
fi

# good aliases
alias cd='z 2>/dev/null || builtin cd' # 'zoxide-aware cd fallback' or whatever that means
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias mkdir='mkdir -p' # unix is so fucking retarded why isnt this default
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias reload='source ~/.zshrc'
command -v nvim &>/dev/null && alias vim='nvim'

if command -v git &> /dev/null; then
    alias gs='git status'
    alias gd='git diff'
    alias ga='git add'
    alias gc='git commit'
    alias gp='git push'
    alias gl='git log --oneline --graph --decorate -20'
fi

if command -v tldr &> /dev/null; then
    alias help='tldr'
fi

if command -v btop &> /dev/null; then
    alias top='btop'
fi

# keybinds for history search (up/down arrows)
if (( ${+widgets[history-substring-search-up]} )); then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=black,bg=green,bold"
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=white,bg=red,bold"
fi
bindkey '^ ' autosuggest-accept   # Ctrl+Space accepts autosuggestions

# ctrl left and right switch words (for some reason this is not default in zsh)
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# alternative escape sequences used by some terminals/multiplexers
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word
bindkey '\eOD' backward-word
bindkey '\eOC' forward-word

# improve completion menu
zstyle ':fzf-tab:*' fzf-flags --height=60%
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath 2>/dev/null'

# run fastfetch on interactive shell startup (laaaaaarp)
if [[ -o interactive ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi
