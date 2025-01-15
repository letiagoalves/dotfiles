function current_dir -d "Get current directory"
    set -l current (pwd)
    if test "$current" = $HOME
      echo "~"
    end
    echo (basename $current)
end

function zellij_update_tab_and_pane_name
    set title (current_dir)
    command nohup zellij action rename-pane $title >/dev/null 2>&1
    command nohup zellij action rename-tab $title >/dev/null 2>&1
end

if status is-interactive
  if set -q ZELLIJ
    if test $ZELLIJ = 0
      function react_to_pwd --on-variable PWD
        zellij_update_tab_and_pane_name
      end

      zellij_update_tab_and_pane_name
    end
  end
end