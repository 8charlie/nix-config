function rebuild --description "nixos-rebuild switch from ~/.dotfiles, offer a commit on success"
    git -C ~/.dotfiles add -A # untracked files are invisible to the flake
    sudo nixos-rebuild switch --flake ~/.dotfiles#(hostname)
    or return
    if git -C ~/.dotfiles status --porcelain | string length -q
        read -P "commit msg (empty to skip): " msg
        test -n "$msg"; and git -C ~/.dotfiles commit -am "$msg"
    end
end
