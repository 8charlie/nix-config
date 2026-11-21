;;; $DOOMDIR/cli.el -*- lexical-binding: t; -*-

;; Loaded by the `doom' CLI only. Keep extra envvar denies here rather than
;; passing them as `doom env -d ...': CLI rules get saved in a ;;;###deny cookie
;; at the top of the envvar file, and Doom only reads the first 256 bytes of it,
;; so a long list breaks every later `doom sync' with end-of-file.
;; `doom-env-deny' is only defined once bin/doom-env loads, after this file.
(with-eval-after-load "doom-env"
  (dolist (re '(;; terminal-specific, wrong for a GUI/daemon Emacs
                "^GHOSTTY_" "^TERM_PROGRAM" "^TMUX"
                ;; set by tools that spawn shells (e.g. Claude Code), not by the login env
                "^GIT_EDITOR$" "^AI_AGENT$" "^CLAUDE"))
    (add-to-list 'doom-env-deny re)))
