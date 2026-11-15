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
export PATH="$HOME/.local/bin:$PATH"
#export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"

# Inside Doom's vterm, evil already gives the buffer a normal mode, so a second
# vi layer only fights it over Esc; normal terminals keep vi mode
if test "$INSIDE_EMACS" = vterm
    fish_default_key_bindings
    # vterm's shell integration: Emacs follows cd, prompt jumping, real `clear`
    source "$EMACS_VTERM_PATH/etc/emacs-vterm.fish"

    # `e file` opens files in this Emacs instead of a nested nvim
    function e
        for f in $argv
            vterm_cmd find-file (realpath $f)
        end
    end
end
