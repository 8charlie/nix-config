;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Private configuration. Unlike init.el and packages.el, changes here don't
;; need a 'doom sync'; 'SPC h r r' (doom/reload) or a restart picks them up.

;; all installed by modules/common/doom-emacs.nix. Aile is Iosevka's
;; proportional sibling, so prose and inline code share the same shapes.
(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 11.0)
      doom-variable-pitch-font (font-spec :family "Iosevka Aile" :size 11.0)
      ;; `SPC t b' (big-font-mode), for presenting or screen sharing
      doom-big-font (font-spec :family "Iosevka Nerd Font" :size 16.0))

;; prose in Aile; code blocks, tables and markup stay monospaced
(add-hook! (org-mode markdown-mode) #'mixed-pitch-mode)

(setq doom-theme 'doom-one
      ;; relative line numbers, as in neovim
      display-line-numbers-type 'relative)

;; line numbers clutter prose, so keep them for code; `SPC t l' toggles them
(add-hook! (org-mode markdown-mode LaTeX-mode) (display-line-numbers-mode -1))

;; a slightly taller modeline; the bar is the strip marking the active window
(setq doom-modeline-height 28
      doom-modeline-bar-width 4)

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
;;; References

;; Zotero (with Better BibTeX) keeps this file up to date via an auto-export of
;; the dissertation collection, so fix entries in Zotero, never here. The PDFs
;; are found through the `file' field it writes. Set at top level rather than
;; in `after! citar': Doom's :tools biblio copies it into org-cite's global
;; bibliography when org-cite loads, which can come first.
(setq citar-bibliography '("~/Documents/work/dissertation/references.bib")
      ;; one org file per source, named by citation key (`SPC n b' opens it)
      citar-notes-paths '("~/Documents/work/dissertation/notes"))

;; `SPC m @' inserts a citation, prompting for \autocite, \textcite, ...; the
;; same key org-mode uses for `org-cite-insert'
(map! :after latex
      :map LaTeX-mode-map
      :localleader
      :desc "Insert citation" "@" #'citar-insert-citation)


;;
;;; LaTeX

;; `SPC m l' toggles continuous compilation, like vimtex's `\ll': latexmk -pvc
;; rebuilds (running biber when needed) every time a file is saved, and its
;; errors and warnings show inline through flymake. texlab's diagnostics stay
;; with flycheck, so the two don't double up. Open the PDF once with `SPC m v';
;; zathura reloads it after each build.
(map! :after latex
      :map LaTeX-mode-map
      :localleader
      :desc "Compile on save" "l" #'auctex-cont-latexmk-toggle)

;; `SPC m v' opens the PDF in Emacs (pdf-tools) rather than zathura, which Doom
;; prefers whenever it's installed. SyncTeX works both ways: `SPC m v' jumps to
;; the cursor's spot, and C-click or double-click in the PDF jumps back.
(setq +latex-viewers '(pdf-tools))

;; Doom only reverts a buffer when you switch to it or save, and latexmk
;; finishes after the save, so poll PDFs instead: they reload within a second
;; of each build. The interval only applies to buffers with `auto-revert-mode'.
(add-hook 'pdf-view-mode-hook #'auto-revert-mode)
(setq auto-revert-interval 1)


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
;;; Claude Code

;; claude-code-ide runs the `claude' CLI in a vterm side window and serves
;; Emacs to it over MCP, so it sees the current file and selection and can use
;; xref, imenu, the project and diagnostics. `SPC o c' opens its menu (start,
;; resume, toggle the window, send the region, ...).
(use-package! claude-code-ide
  :defer t
  :init
  (map! :leader :desc "Claude Code" "o c" #'claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))


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
