set fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here

    # testing startup time
    # fish --profile-startup /tmp/fish.profile -i -c exit

    fish_add_path "$HOME/homebrew/bin"
    fish_add_path "$HOME/workspace/github/git-fuzzy/bin"
    fish_add_path "$HOME/.cargo/bin"
    fish_add_path "$HOME/.local/share/bob/nvim-bin"

    starship init fish | source
    zoxide init fish | source
end

