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

function current_dir() {
    local current_dir=$PWD
    if [[ $current_dir == $HOME ]]; then
        current_dir="~"
    else
        current_dir=${current_dir##*/}
    fi
    echo $current_dir
}

function change_pane_title() {
    local title=$1
    command nohup zellij action rename-pane $title >/dev/null 2>&1
}

function set_pane_to_working_dir() {
    local result=$?
    local title=$(current_dir)
    # uncomment the following to show the exit code after a failed command
    # if [[ $result -gt 0 ]]; then
    #     title="$title [$result]" 
    # fi

    change_pane_title $title
}

function set_pane_to_command_line() {
    local cmdline=$1
    change_pane_title $cmdline
}

if [[ -n $ZELLIJ ]]; then
    add-zsh-hook precmd set_pane_to_working_dir
    add-zsh-hook preexec set_pane_to_command_line
fi
