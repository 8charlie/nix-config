;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Private configuration. Unlike init.el and packages.el, changes here don't
;; need a 'doom sync'; 'SPC h r r' (doom/reload) or a restart picks them up.

;; same font as ghostty; installed by modules/common/doom-emacs.nix
(setq doom-font (font-spec :family "BlexMono Nerd Font" :size 11.0))

(setq doom-theme 'doom-one
      ;; relative line numbers, as in neovim
      display-line-numbers-type 'relative)

(setq org-directory "~/org/")

;; fish isn't POSIX, which trips up Emacs utilities that run shell commands
;; (diff-hl, TRAMP, ...), so run those through bash; terminals still get fish
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish")
              explicit-shell-file-name (executable-find "fish"))

;; British English spell checking in text modes (markdown, latex, org, ...), as
;; in the neovim ftplugins. `z=' corrects, `zg' adds a word, `]s' / `[s' jump.
(setq ispell-dictionary "en_GB")
;; don't flag \cite / \ref / \label keys
(after! spell-fu
  (cl-callf append (alist-get 'latex-mode +spell-excluded-faces-alist)
    '(font-lock-constant-face)))


;;
;;; Formatting

;; Format on save with the same tools conform.nvim uses. Rust (rustfmt) and C
;; (clang-format) are already Apheleia's defaults; Python and Nix are not.
(after! apheleia
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode))
  (set-formatter! 'alejandra '("alejandra" "--quiet" "-")
    :modes '(nix-mode nix-ts-mode)))


;;
;;; LSP

;; basedpyright's default "recommended" mode is too strict
(setq-default eglot-workspace-configuration
              '(:basedpyright (:analysis (:typeCheckingMode "standard"))))


;;
;;; Keybinds

;; Outside a project root, Doom's `SPC f F' falls back to project.el, which
;; blocks Emacs on a `find -L' of the whole tree. From ~ (the dashboard) that
;; follows every wine prefix's `z: -> /' symlink and never finishes. fd runs
;; async, searches as you type and doesn't follow symlinks.
(map! :leader
      :desc "Find file from here" "f F"
      (cmd! (+vertico/consult-fd-or-find default-directory)))

;; evil-markdown and evil-org take gj/gk for heading/element navigation; give
;; them back to visual-line movement, as in vim
(map! :after evil-markdown
      :map evil-markdown-mode-map
      :nv "gj" #'evil-next-visual-line
      :nv "gk" #'evil-previous-visual-line)
(map! :after evil-org
      :map evil-org-mode-map
      :nv "gj" #'evil-next-visual-line
      :nv "gk" #'evil-previous-visual-line)

;; centre the screen after a half-page scroll, as in neovim
(defun +scroll-down-centred (&optional count)
  "Scroll down half a page (or COUNT lines), then centre the cursor line."
  (interactive "P")
  (evil-scroll-down count)
  (evil-scroll-line-to-center nil))
(defun +scroll-up-centred (&optional count)
  "Scroll up half a page (or COUNT lines), then centre the cursor line."
  (interactive "P")
  (evil-scroll-up count)
  (evil-scroll-line-to-center nil))
(map! :n "C-d" #'+scroll-down-centred
      :n "C-u" #'+scroll-up-centred)

;; switch between windows, as in neovim; costs `,' (reverse f/t repeat) there too
(map! :n ",h" #'evil-window-left
      :n ",j" #'evil-window-down
      :n ",k" #'evil-window-up
      :n ",l" #'evil-window-right)
