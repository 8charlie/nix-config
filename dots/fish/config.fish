if test (uname) = Darwin
    abbr -a drs 'sudo darwin-rebuild switch --flake ~/.dotfiles'
else
    abbr -a nrs 'sudo nixos-rebuild switch --flake ~/.dotfiles'
end

fish_vi_key_bindings

# For editing commands from neovim (use alt+e/alt+v)
set -gx EDITOR nvim
set -gx VISUAL nvim

set -U fish_greeting ""
set fish_cursor_default block
set fish_cursor_insert line
# fish_add_path skips dirs already on PATH, so nested shells don't stack it
fish_add_path -g ~/.local/bin
#export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"

# Inside Doom's ghostel, evil already gives the buffer a normal mode, so a
# second vi layer only fights it over Esc; normal terminals keep vi mode.
# Ghostel injects its own fish integration automatically (cd tracking, prompts,
# and `ghostel_cmd`).
if test "$INSIDE_EMACS" = ghostel
    fish_default_key_bindings
    # open git commits, Alt+E command edits, etc. in this Emacs instead of nested nvim
    set -gx EDITOR emacsclient
    set -gx VISUAL emacsclient

    # `e file` opens files in this Emacs instead of a nested nvim
    function e
        for f in $argv
            ghostel_cmd find-file (realpath $f)
        end
    end
end
