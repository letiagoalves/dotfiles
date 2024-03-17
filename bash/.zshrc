source "/Users/tiagoalves/.bash_aliases"
source "/Users/tiagoalves/.zshrc_custom"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# pnpm
export PNPM_HOME="/Users/tiagoalves/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval $(/opt/homebrew/bin/brew shellenv)

eval "$(rbenv init - zsh)"
eval "$(pyenv init --path)"
source "$HOME/.cargo/env"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /Users/tiagoalves/workspace/github.com/ohmyzsh/plugins/git/git.plugin.zsh
source /Users/tiagoalves/workspace/github.com/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /Users/tiagoalves/workspace/github.com/dotfiles/zsh/completion.zsh

autoload -Uz compinit
compinit -u

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
