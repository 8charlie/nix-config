;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Private configuration. Unlike init.el and packages.el, changes here don't
;; need a 'doom sync'; 'SPC h r r' (doom/reload) or a restart picks them up.

;; BlexMono matches ghostty (dots/ghostty/config); IBM Plex Sans is its
;; proportional sibling so prose and inline code share the same shapes.
(setq doom-font (font-spec :family "BlexMono Nerd Font" :size 11.0)
      doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size 11.0)
      ;; `SPC t b' (big-font-mode), for presenting or screen sharing
      doom-big-font (font-spec :family "BlexMono Nerd Font" :size 16.0))

;; prose in IBM Plex Sans; code blocks, tables and markup stay monospaced
(add-hook! (org-mode markdown-mode) #'mixed-pitch-mode)

(setq doom-theme 'doom-one
      ;; relative line numbers, as in neovim
      display-line-numbers-type 'relative)

;; a slightly taller modeline; the bar is the strip marking the active window
(setq doom-modeline-height 28
      doom-modeline-bar-width 4)

;; translucent background, as in ghostty (background-opacity = 0.90); text
;; stays opaque. In `default-frame-alist' so the daemon's client frames get it.
;; pgtk only: the macOS build ignores it.
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; ghostty's 12px window padding: around the frame edge and between splits.
;; The mode-line box is kept thin because doom-modeline already sets a height.
;; Keys left out fall back to spacious-padding's defaults.
(use-package! spacious-padding
  :config
  (setq spacious-padding-widths
        '(:internal-border-width 12
          :right-divider-width 12
          :mode-line-width 1
          :header-line-width 4
          :fringe-width 8))
  (spacious-padding-mode 1))

(setq org-directory "~/org/")

;; render inline LaTeX in org files on open; org-fragtog shows the source while
;; the cursor is inside a fragment and re-renders it on leaving
(after! org
  (setq org-startup-with-latex-preview t
        ;; SVG stays crisp at any scale, unlike the default dvipng
        org-preview-latex-default-process 'dvisvgm)
  (plist-put org-format-latex-options :scale 1.5))

(add-hook 'org-mode-hook #'org-fragtog-mode)

;; fish isn't POSIX, which trips up Emacs utilities that run shell commands
;; (diff-hl, TRAMP, ...), so run those through bash; terminals still get fish
(setq shell-file-name (executable-find "bash"))
(setq-default ghostel-shell (executable-find "fish")
              explicit-shell-file-name (executable-find "fish"))

(after! ghostel
  (setq ghostel-timer-delay 0.01               ; 10ms redraw batching (default ~33ms)
        ghostel-kill-buffer-on-exit t          ; `exit' / C-d closes the buffer cleanly
        ghostel-max-scrollback (* 10 1024 1024)) ; 10 MiB (ghostel measures bytes, not lines)

  ;; ensure emacsclient works from inside ghostel (e.g. EDITOR=emacsclient on macOS)
  (require 'server)
  (unless (server-running-p)
    (server-start)))

;; British English spell checking in text modes (markdown, latex, org, ...), as
;; in the neovim ftplugins. `z=' corrects, `zg' adds a word, `]s' / `[s' jump.
(setq ispell-dictionary "en_GB")
;; and British grammar for LanguageTool (`M-x langtool-check'); the
;; :checkers grammar module defaults to en-US
(setq langtool-default-language "en-GB")
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

;; claude-code-ide runs the `claude' CLI in a ghostel side window and serves
;; Emacs to it over MCP, so it sees the current file and selection and can use
;; xref, imenu, the project and diagnostics. `SPC o c' opens its menu (start,
;; resume, toggle the window, send the region, ...).
(use-package! claude-code-ide
  :defer t
  :init
  (setq claude-code-ide-terminal-backend 'ghostel)
  (map! :leader :desc "Claude Code" "o c" #'claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))

;; vterm moves point back to the terminal cursor and recentres the window on
;; every redraw, and Claude Code redraws all the time (spinner, prompt box), so
;; scrolling up in normal state snaps straight back down. `vterm-copy-mode'
;; pauses the terminal instead (pty flow control, so no output is lost), so
;; tie it to evil's states in Claude buffers, like a neovim terminal: normal
;; state freezes the transcript to scroll, search and yank; insert state
;; resumes it, catching up on whatever Claude wrote in the meantime.
(defun +claude-code-buffer-p ()
  "Return non-nil if the current buffer is a claude-code-ide vterm session."
  (and (derived-mode-p 'vterm-mode)
       (string-prefix-p "*claude-code[" (buffer-name))))
(add-hook! 'evil-normal-state-entry-hook
  (defun +claude-code-freeze-h ()
    (when (and (+claude-code-buffer-p) (not vterm-copy-mode))
      (vterm-copy-mode 1))))
(add-hook! 'evil-insert-state-entry-hook
  (defun +claude-code-thaw-h ()
    (when (and (+claude-code-buffer-p) vterm-copy-mode)
      (vterm-copy-mode -1))))


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
