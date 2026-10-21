#!/bin/bash
export BASH_SILENCE_DEPRECATION_WARNING=1

set -o vi
bind -m vi-insert "\C-l":clear-screen

export LESS="-R"
export EDITOR=nvim
export HISTFILESIZE=-1
export LC_ALL=en_US.UTF-8
export HISTCONTROL=ignoreboth:erasedups
export GOPATH="$HOME/src/go"
export PATH="$HOME/.cargo/bin:$GOPATH/bin:$HOME/.local/bin:$HOME/bin:$HOME/Library/pnpm/bin:$(brew --prefix)/bin:$(brew --prefix)/sbin:$(brew --prefix git)/bin:$PATH"
export PS1="\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\!]\e[0m[\e[0;32m\d \t \e[0;34m\u@\H:\w\e[0m\$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/{\1}/')]\\n\\$ "

eval "$(direnv hook bash)"
[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
for f in $(brew --prefix)/etc/bash_completion.d/*; do
        [ -f "$f" ] && . "$f"
done

alias vim='nvim'
alias ls='ls -F --color=auto'
alias topgrade='NO_COLOR=1 HOMEBREW_NO_ASK=1 CARGO_INSTALL_OPTS="--locked" topgrade'

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
