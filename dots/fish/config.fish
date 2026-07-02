if status is-interactive
    # Commands to run in interactive sessions can go here
	function see
		builtin cd $argv[1]; and timeout 1s ls
	end
	function rebuild
    	cd ~/.dotfiles
    	git add -A   # flakes can't see untracked files anyway
    	sudo nixos-rebuild switch --flake .#(hostname)
    	and begin
    	    read -P "commit? (empty to skip): " msg
    	    test -n "$msg"; and git commit -am "$msg"
    	end
	end
end

alias vi=nvim

fish_vi_key_bindings

set -U fish_greeting ""
set fish_cursor_default block
set fish_cursor_insert line
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"


