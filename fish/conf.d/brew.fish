if not command --query brew
    set --local prefixes $HOME/.brew $HOME/.linuxbrew /opt/homebrew /usr/local
    set --query --universal __homebrew_prefix
    and set --prepend prefixes $__homebrew_prefix

    for prefix in $prefixes
        test -x $prefix/bin/brew
        or continue

        set --prepend PATH $prefix/bin
        break
    end
end
