{
  # Stop assorted tools from dumping dotfiles/dot-dirs straight into $HOME by
  # pointing them at the XDG base dirs.
  #
  # NOTE: these only change where each tool writes from now on. Existing files
  # are left in place — move or delete them yourself once you've rebuilt.
  environment.sessionVariables = {
    # Set these explicitly as some applications only follow XDG when the
    # variables are present, even though these are the specification defaults.
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";

    # ---- config -> ~/.config ----
    CLAUDE_CONFIG_DIR = "$HOME/.config/claude";
    GIT_CONFIG_GLOBAL = "$HOME/.config/git/config";
    GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc";
    IPYTHONDIR = "$HOME/.config/ipython";
    NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
    WGETRC = "$HOME/.config/wget/wgetrc";

    # opts jupyter into platformdirs: config -> ~/.config/jupyter,
    # data -> ~/.local/share/jupyter (unchanged), runtime -> XDG. Also silences
    # the "migrate to jupyter_platform_dirs" deprecation warning.
    JUPYTER_PLATFORM_DIRS = "1";

    # ---- data -> ~/.local/share ----
    CARGO_HOME = "$HOME/.local/share/cargo";

    # ---- cache -> ~/.cache ----
    CUDA_CACHE_PATH = "$HOME/.cache/nvidia/ComputeCache";
    ICEAUTHORITY = "$HOME/.cache/ICEauthority";
    NPM_CONFIG_CACHE = "$HOME/.cache/npm";
    XCOMPOSECACHE = "$HOME/.cache/X11/xcompose";

    # ---- state / history -> ~/.local/state ----
    # (parent dirs pre-created below; these tools won't mkdir them themselves)
    HISTFILE = "$HOME/.local/state/bash/history";
    PYTHON_HISTORY = "$HOME/.local/state/python/history"; # python >= 3.13
    NODE_REPL_HISTORY = "$HOME/.local/state/node/history";

  # Some tools write the file but not its parent directory. Wget also needs a
  # real config file: WGETRC pointing at a missing file is a fatal error.
  systemd.user.tmpfiles.users.charlie.rules = [
    "d %h/.config/git 0755 - - -"
    "d %h/.config/gtk-2.0 0755 - - -"
    "d %h/.config/npm 0755 - - -"
    "d %h/.config/vim 0755 - - -"
    "d %h/.config/wget 0755 - - -"
    "f %h/.config/wget/wgetrc 0644 - - - hsts-file\\x20=\\x20%h/.local/state/wget/hsts"
    "d %h/.cache/X11/xcompose 0755 - - -"
    "d %h/.cache/nvidia/ComputeCache 0755 - - -"
    "d %h/.local/state/bash 0755 - - -"
    "d %h/.local/state/python 0755 - - -"
    "d %h/.local/state/node 0755 - - -"
    "d %h/.local/state/less 0755 - - -"
    "d %h/.local/state/sqlite 0755 - - -"
    "d %h/.local/state/vim 0755 - - -"
    "d %h/.local/state/wget 0755 - - -"
  ];
}
