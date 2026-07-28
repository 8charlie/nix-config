abbr -a nrs 'sudo nixos-rebuild switch --flake ~/.dotfiles'

fish_vi_key_bindings

# For editing commands from neovim (use alt+e/alt+v)
set -gx EDITOR nvim
set -gx VISUAL nvim

set -U fish_greeting ""
set fish_cursor_default block
set fish_cursor_insert line
export PATH="$HOME/.local/bin:$PATH"
#export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"
