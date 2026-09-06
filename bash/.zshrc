source "/Users/tiagoalves/.bash_aliases"
source "/Users/tiagoalves/.zshrc_custom"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# pnpm
export PNPM_HOME="/Users/tiagoalves/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval $(/opt/homebrew/bin/brew shellenv)

# fnm - the only Node version manager on this machine (nvm was removed).
# Mirrors fish/conf.d/fnm.fish. Must come after brew shellenv: the
# --use-on-cd hook calls `fnm` unqualified, so it needs /opt/homebrew/bin.
eval "$(fnm env --use-on-cd --shell zsh)"

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

# Added by Antigravity
export PATH="/Users/tiagoalves/.antigravity/antigravity/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tiagoalves/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tiagoalves/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tiagoalves/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tiagoalves/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Added by Antigravity IDE
export PATH="/Users/tiagoalves/.antigravity-ide/antigravity-ide/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/tiagoalves/.antigravity-ide/antigravity-ide/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/tiagoalves/.antigravity-ide/antigravity-ide/bin:$PATH"

# bun completions
[ -s "/Users/tiagoalves/.bun/_bun" ] && source "/Users/tiagoalves/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
