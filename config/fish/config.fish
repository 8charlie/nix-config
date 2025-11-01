if status is-interactive
    # Commands to run in interactive sessions can go here
	function see
		builtin cd $argv[1]; and timeout 1s ls
	end
end

alias switch1='sudo nixos-rebuild switch --flake ~/.dotfiles#nixos'
alias switch2='sudo nixos-rebuild switch --flake ~/.dotfiles#home'
alias vim=nvim

fish_vi_key_bindings

set -U fish_greeting ""
set fish_cursor_default block
set fish_cursor_insert line
