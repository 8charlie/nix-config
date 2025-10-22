if status is-interactive
    # Commands to run in interactive sessions can go here
	function see
		builtin cd $argv[1]; and timeout 1s ls
	end
end

set -U fish_greeting ""
set -x PATH /opt/homebrew/bin $PATH

fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line

alias vim=nvim
alias fd=fdfind
