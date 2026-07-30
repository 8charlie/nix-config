{
  # Stop assorted tools from dumping dotfiles/dot-dirs straight into $HOME by
  # pointing them at the XDG base dirs.
  #
  # NOTE: these only change where each tool writes from now on. Existing files
  # are left in place — move or delete them yourself once you've rebuilt.
  environment.sessionVariables = {
    # ---- config -> ~/.config ----
    IPYTHONDIR = "$HOME/.config/ipython";
    CLAUDE_CONFIG_DIR = "$HOME/.config/claude";

    # opts jupyter into platformdirs: config -> ~/.config/jupyter,
    # data -> ~/.local/share/jupyter (unchanged), runtime -> XDG. Also silences
    # the "migrate to jupyter_platform_dirs" deprecation warning.
    JUPYTER_PLATFORM_DIRS = "1";

    # ---- data -> ~/.local/share ----
    CARGO_HOME = "$HOME/.local/share/cargo";

    # ---- cache -> ~/.cache ----
    NPM_CONFIG_CACHE = "$HOME/.cache/npm";

    # ---- state / history -> ~/.local/state ----
    # (parent dirs pre-created below; these tools won't mkdir them themselves)
    HISTFILE = "$HOME/.local/state/bash/history";
    PYTHON_HISTORY = "$HOME/.local/state/python/history"; # python >= 3.13
    NODE_REPL_HISTORY = "$HOME/.local/state/node/history";
    LESSHISTFILE = "$HOME/.local/state/less/history";
    SQLITE_HISTORY = "$HOME/.local/state/sqlite/history";
  };

  # History-file tools write the file but not its parent directory; without
  # these they'd silently keep no history.
  systemd.user.tmpfiles.users.charlie.rules = [
    "d %h/.local/state/bash 0755 - - -"
    "d %h/.local/state/python 0755 - - -"
    "d %h/.local/state/node 0755 - - -"
    "d %h/.local/state/less 0755 - - -"
    "d %h/.local/state/sqlite 0755 - - -"
  ];
}
