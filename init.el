;-*- lexical-binding: t -*-
 ;;;;; My Emacs Config 
 ;;;;; lasviceju@gmail.com

 ;;;; Core

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

 ;;; straght.el
 (defvar bootstrap-version)
 (setq straight-disable-native-compile t)
 (let ((bootstrap-file
        (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
       (bootstrap-version 5))
   (unless (file-exists-p bootstrap-file)
     (with-current-buffer
         (url-retrieve-synchronously
          "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
          'silent 'inhibit-cookies)
       (goto-char (point-max))
       (eval-print-last-sexp)))
   (load bootstrap-file nil 'nomessage))
 (straight-use-package 'use-package)
 (setq straight-use-package-by-default t)

 (use-package el-patch
   :init
   (setq el-patch-enable-use-package-integration t))

 (use-package dash)

 (use-package s)

(use-package exwm
  :disabled
  :config
  (defun my/exwm-config-example ()
    (require 'exwm-randr)
    (exwm-randr-enable)
    (start-process-shell-command "xrandr" nil "xrandr --output HDMI-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal")
    (set-frame-parameter (selected-frame) 'alpha '(90 . 90))

    ;; Set the initial workspace number.
    (setq exwm-workspace-number 4)
    ;; Make class name the buffer name
    (add-hook 'exwm-update-class-hook
              (lambda ()
                (exwm-workspace-rename-buffer exwm-class-name)))
    ;; Global keybindings.
    (setq exwm-input-global-keys
          `(
            ;; 's-r': Reset (to line-mode).
            ([?\s-r] . exwm-reset)
            ;; 's-w': Switch workspace.
            ;; ([?\s-w] . exwm-workspace-switch)
            ;; 's-&': Launch application.
            ([?\s-&] . (lambda (command)
                         (interactive (list (read-shell-command "$ ")))
                         (start-process-shell-command command nil command)))
            ;; 's-N': Switch to certain workspace.
            ,@(mapcar (lambda (i)
                        `(,(kbd (format "s-%d" i)) .
                          (lambda ()
                            (interactive)
                            (exwm-workspace-switch-create ,i))))
                      (number-sequence 0 9))
            (,(kbd "s-o") . delete-other-windows)
            (,(kbd "s-w") . delete-window)
            ([s-left] . windmove-left)
            ([s-right] . windmove-right)
            ([s-up] . windmove-up)
            ([s-down] . windmove-down)
            ([?\s-m] . maximize-window)
            ([?\s-M] . winner-undo)
            ([?\s-j] . other-window)
            ([?\s-k] . (lambda () (interactive) (other-window -1)))
            (,(kbd "s-<return>") . (lambda () (interactive)(split-window-horizontally) (other-window 1)))
            (,(kbd "s-S-<return>") . (lambda () (interactive)(split-window-vertically) (other-window 1)))
            ([?\s-t] . eshell-other-window)
            (,(kbd "s-}") . winner-redo)
            (,(kbd "s-[") . previous-buffer)
            (,(kbd "s-]") . next-buffer)
            (,(kbd "s-{") . winner-undo)))

    (setq exwm-input-simulation-keys
          '(([?\C-b] . [left])
            ([?\C-f] . [right])
            ([?\C-p] . [up])
            ([?\C-n] . [down])
            ([?\C-a] . [home])
            ([?\C-e] . [end])
            ([?\M-v] . [prior])
            ([?\C-v] . [next])
            ([?\C-d] . [delete])
            ([?\C-k] . [S-end delete])))
    (setq exwm-input-prefix-keys
          '(?\C-x
            ?\C-u
            ?\C-h
            ?\M-x
            ?\M-`
            ?\M-:
            ?\C-\M-j ; Buffer list
            ?\M-\ )) ; Meta+SPC
    (exwm-enable))
  (my/exwm-config-example))

(use-package emacs
  :init
  (setq delete-by-moving-to-trash t)
  ;; (setq trash-directory "~/.Trash")
  (setq system-time-locale "en_US.UTF-8")
  ;; Startup
  (setq inhibit-startup-screen t)
  (setq inhibit-startup-message t)
  (setq inhibit-startup-echo-area-message t)
  (setq initial-scratch-message nil)
  (setq initial-buffer-choice nil)
  (setq frame-title-format nil)
  (setq use-file-dialog nil)
  (setq use-dialog-box nil)
  (setq pop-up-windows t)
  (setq indicate-empty-lines nil)
  (setq cursor-in-non-selected-windows nil)
  (setq initial-major-mode 'text-mode)
  (setq default-major-mode 'text-mode)
  (setq font-lock-maximum-decoration nil)
  (setq font-lock-maximum-size nil)
  (setq auto-fill-mode nil)
  (setq frame-resize-pixelwise t) ; fix crash on stumpwm gaps
  ;; (setq fill-column 80)
  (if (fboundp 'scroll-bar-mode)
      (scroll-bar-mode -1))
  (if (fboundp 'tool-bar-mode)
      (tool-bar-mode nil))
  (setq default-frame-alist
        (append (list
                 ;; '(min-height . 1)  '(height . 45)
                 ;; '(min-width  . 1)  '(width  . 81)
                 '(fullcreen . maximized)
                 '(vertical-scroll-bars . nil)
                 '(internal-border-width . 24)
                 '(left-fringe . 0)
                 '(right-fringe . 0)
                 '(tool-bar-lines . 0)
                 '(menu-bar-lines . 0))))
  ;; transparency
  (add-to-list 'default-frame-alist '(alpha . (97 . 97)))
  (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  ;; font
  (add-to-list 'default-frame-alist '(font . "Fira Code-12"))
  (custom-theme-set-faces
   'user
   '(variable-pitch ((t (:family "Fira Code" :height 120))))
   '(fixed-pitch ((t ( :family "Fira Code" :height 120)))))


  (setq-default cursor-type '(hbar .  2))
  (setq-default cursor-in-non-selected-windows nil)
  (setq blink-cursor-mode nil)
  (setq line-spacing 0)
  (setq window-divider-default-right-width 12)
  (setq window-divider-default-places 'right-only)
  (window-divider-mode 1)
  ;; indent
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq indent-line-function 'insert-tab)
  ;; Mac command key and option key
  (when (eq system-type 'darwin)
    (setq mac-option-modifier 'meta
          mac-command-modifier 'super
          mac-option-key-is-meta t))
  (setq ring-bell-function 'ignore)

  :config
  (require 'cl)
  ;; emacs server
  ;; (server-start)
  (global-visual-line-mode)
  (delete-selection-mode nil)
  (setq tab-always-indent 'complete))

  ;; (when (member "Fira Code" (font-family-list))
  ;;   (set-frame-font "Fira Code-12" t t))

(use-package atom-one-dark-theme
  :config
  (load-theme 'atom-one-dark t)
  )

(use-package gruvbox-theme)

(use-package modus-themes
  :init
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-region '(bg-only no-extend))

  ;; Load the theme files before enabling a theme
  (modus-themes-load-themes)
  :config
  ;; Load the theme of your choice:
  ;; (modus-themes-load-operandi) ;; OR (modus-themes-load-vivendi)
  )

(use-package twilight-bright-theme)

(use-package twilight-anti-bright-theme)

(use-package smart-mode-line
  :config
  (setq sml/theme 'respectful)
  (sml/setup))

(use-package key-chord
  :config
  (key-chord-mode 1))

(use-package undo-fu)

(use-package evil
  :init
  (setq evil-undo-system 'undo-fu)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-want-C-u-delete t)
  ;; Don't move cursor backward when exiting insert mode
  (setq evil-move-cursor-back nil)
  (setq evil-move-beyond-eol t)
  ;; Don't replace kill ring when pasting
  (setq evil-kill-on-visual-paste nil)
  ;; Enable most emacs keybindings in insert state
  ;; (setq evil-disable-insert-state-bindings t)
  :config
  ;; (evil-set-initial-state 'exwm-mode 'insert)
  (evil-mode))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-company-use-tng nil)
  (evil-collection-init))

(use-package evil-commentary
  :config
  (evil-commentary-mode))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package general
  :config
  (general-define-key
   ;; :keymaps 'evil-insert-state-map
   :states '(insert)
   ;; :keymaps 'override
   (general-chord "jk") 'evil-normal-state
   (general-chord "kj") 'evil-normal-state)

  (general-define-key
   :states '(normal visual insert emacs motion)
   ;; :keymaps 'override
   "M-i" 'evil-force-normal-state
   "M-m" 'maximize-window
   "M-j" 'other-window
   "M-J" (lambda () (interactive) (other-window -1))
   "M-<return>" (lambda () (interactive)(split-window-horizontally) (other-window 1))
   "M-S-<return>" (lambda () (interactive)(split-window-vertically) (other-window 1))
   "M-t" 'eshell-other-window
   "M-[" 'previous-buffer
   "M-]" 'next-buffer
   "M-{" 'winner-undo
   "M-}" 'winner-redo
   "M-o" 'delete-other-windows
   "M-w" 'delete-window
   "M-W" 'kill-current-buffer
   "M-+" 'text-scale-increase
   "M-_" 'text-scale-decrease
   "M-)" 'text-scale-mode
   "C-S-v" 'yank
   "<f5>" 'my/change-theme
   "<f6>" 'org-babel-tangle
   "C-S-j" 'join-line
   "C-j" 'default-indent-new-line)

  (general-define-key
   :keymaps 'minibuffer-local-map
   "C-V" 'yank
   "C-u" (lambda () (interactive) (kill-line 0)))

  (general-define-key
   ;; :states '(normal visual motion)
   ;; :prefix "SPC"
   ;; :non-normal-prefix "M-SPC"
   :keymaps '(normal insert emacs motion)
   :prefix "SPC"
   ;; :non-normal-prefix "M-SPC"
   :global-prefix "M-SPC"
   ;; :keymaps 'override

   "" '(nil :which-key "keymapping")
   "SPC" 'consult-buffer
   ";" 'eval-expression
   "g" 'magit
   "`" (lambda () (interactive) (switch-to-buffer (other-buffer (current-buffer) 1)))

   "s" '(:ignore t :which-key "search")
   "ss" 'consult-line
   "si" 'consult-imenu
   "sr" 'iedit-mode

   "f" '(:ignore t :which-key "file")
   "ff" 'find-file
   "fs" 'save-buffer
   "fd" 'dired
   "fD" (lambda () (interactive) (shell-command "open ."))

   "o" '(:ignore t :which-key "open")
   "ot" 'vterm-other-window  

   "i" '(:ignore t :wk "input")
   "ii" 'unicode-math-input
   "iu" 'insert-char

   "b" '(:ignore t :wk "buffer")
   "bd" 'kill-current-buffer

   "b" '(:ignore t :wk "window")
   "wd" 'delete-window
   "ww" 'other-window

   "t" '(:ignore t :which-key "toggle")
   "to" 'olivetti-mode)

  ;; for other
  (general-define-key
   :states '(normal visual insert emacs)
   :keymaps 'global
   "C-a" 'beginning-of-visual-line
   "C-e" 'end-of-visual-line
   "C-k" 'kill-line
   "C-S-u" 'universal-argument
   )

  (general-define-key
   :states '(insert normal emacs visual)
   :keymaps '(lispy-mode-map emacs-lisp-mode-map)
   "M-<return>" 'eval-last-sexp
   "M-S-<return>" 'eval-defun)

  (general-define-key
   :states '(insert emacs)
   :keymaps '(text-mode-map fundamental-mode-map prog-mode-map org-mode-map)
   "C-u" (lambda () (interactive) (kill-line 0)))

  (general-define-key
   :state '(insert emacs)
   :keymaps 'vterm-mode-map
   "C-u" 'vterm-send-C-u)

  (general-define-key
   :state '(normal)
   :keymaps 'markdown-mode-map
   "<tab>" 'markdown-cycle)

  (general-define-key
   :states '(normal visual)
   :keymaps '(prog-mode-map text-mode-map fundamental-mode-map org-mode-map  vterm-mode-map nov-mode-map)
   "`" 'beacon-blink
   "f" 'avy-goto-word-1
   "F" 'evil-avy-goto-line
   "J" (lambda () (interactive) (scroll-up-command 1) (forward-line 1))
   "K" (lambda () (interactive) (scroll-up-command -1) (forward-line -1))))

(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'"))

(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ;; ("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . markdown-mode))
  ;; ("\\.markdown\\'" . gfm-mode))
  :hook
  (markdown-mode . variable-pitch-mode)
  (markdown-mode . (lambda ()
                     ;; (setq markdown-hide-urls t)
                     (markdown-display-inline-images)
                     (setq markdown-hide-markup nil)
                     (markdown-enable-header-scaling)
                     (setq markdown-enable-prefix-prompts nil)
                     (setq markdown-enable-math t)))
  :init
  (defun markdown-enable-header-scaling ()
    (interactive)
    (setq markdown-header-scaling t)
    (markdown-update-header-faces t  '(1.3 1.2 1.1 1.0 1.0 1.0)))
  (setq markdown-xhtml-header-content
        (concat "<script type=\"text/javascript\" async"
                " src=\"https://cdnjs.cloudflare.com/ajax/libs/mathjax/"
                "2.7.1/MathJax.js?config=TeX-MML-AM_CHTML\">"
                "</script>"))
  (setq markdown-command "multimarkdown")
  (setq markdown-asymmetric-header t)
  (setq markdown-indent-on-enter 'indent-and-new-item)
  (setq markdown-display-remote-images t)
  (setq markdown-electric-backquote t)
  (setq markdown-fontify-code-blocks-natively t)
  (setq markdown-enable-wiki-links t)
  (setq markdown-enable-math t)
  ;; (setq markdown-live-preview-window-function 'markdown-live-preview-window-xwidget)
  (setq markdown-open-command "/usr/local/bin/mark")
  (setq markdown-max-image-size '(500 . 500))
  ;; (evil-define-key 'normal 'markdown-mode-map (kbd "RET") 'markdown-follow-wiki-link-at-point)
  :bind
  (:map markdown-mode-map
        ("C-<left>" . markdown-promote)
        ("C-<right>" . markdown-demote)
        ("C-<up>" . markdown-move-up)
        ("C-<down>" . markdown-move-down)))

(use-package plantuml-mode
  :after org
  :init
  (setq org-plantuml-jar-path "/opt/homebrew/Cellar/plantuml/1.2021.8/libexec/plantuml.jar")
  (setq org-plantuml-default-exec-mode 'jar)
  (setq plantuml-jar-path "/opt/homebrew/Cellar/plantuml/1.2021.8/libexec/plantuml.jar")
  (setq plantuml-default-exec-mode 'jar)
  (add-to-list
  'org-src-lang-modes '("plantuml" . plantuml)))

(use-package cider
  :after org
  :bind
  (:map clojure-mode-map
        ("M-<return>" . cider-eval-last-sexp)
        ("C-c C-s" . cider-jack-in))
  :init
  (setq org-babel-clojure-backend 'cider)
  (require 'cider))

(use-package lsp-mode
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  :hook
  ((java-mode . lsp)
   (ruby-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui
  :init
  (setq lsp-ui-doc-enable nil)
  ;; (setq lsp-ui-show-hover t)
  (setq lsp-ui-sideline-show-diagnostics nil
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-code-actions nil))

(use-package lsp-java)

(use-package swift-mode)

(use-package sml-mode)

(use-package haskell-mode
  :config
  (electric-pair-local-mode -1))

(use-package lsp-haskell)

(use-package clojure-mode)

(use-package promela-mode
  :straight (:host github :repo "rudi/promela-mode")
  :mode "\\.pml\\'")

(use-package alloy-mode
  :straight (:host github :repo "dwwmmn/alloy-mode")
  :mode "\\.als\\'")

(use-package slime
  :init
  (setq inferior-lisp-program "sbcl"))

(defun my/put-file-name-on-clipboard ()
    "Put the current file name on the clipboard"
    (interactive)
    (let ((filename (if (equal major-mode 'dired-mode)
                        default-directory
                      (buffer-file-name))))
      (when filename
        (with-temp-buffer
          (insert filename)
          (clipboard-kill-region (point-min) (point-max)))
        (message filename))))

(defun my/delete-current-file ()
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (when (y-or-n-p (concat "Delete file " filename "?"))
            (progn
              (delete-file filename t)
              (message "%s deleted" filename)
              (kill-buffer)
              (when (> (length (window-list)) 1)
                (delete-window))))
      (message "It's not a file."))))

(defun my/rename-current-file ()
  "rename current file name"
  (interactive)
  (let ((name (buffer-name))
        (file-name (buffer-file-name)))
    (if file-name
        (let ((new-name (read-from-minibuffer
                         (concat "New name for: ")
                         file-name)))
          (if (get-buffer new-name)
              (message "A buffer named %s already exists." new-name)
            (progn
              (rename-file file-name new-name)
              (set-visited-file-name new-name)
              (set-buffer-modified-p nil))))
      (message "This buffer is not visiting a file."))))

(defun my/change-theme ()
  (interactive)
  (let ((theme (completing-read "Select a theme: "
                                custom-known-themes)))
    (dolist (theme custom-enabled-themes)
      (disable-theme theme))
    (load-theme (intern theme) t)))

(use-package avy
  :after key-chord
  :config
  (avy-setup-default))

(use-package vertico
  :init
  (vertico-mode)
  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)
  ;; (setq vertico-count 20)
  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)
  (setq vertico-cycle t)
  (setq enable-recursive-minibuffers t)
  (setq read-file-name-completion-ignore-case t
        read-buffer-completion-ignore-case t
        completion-ignore-case t)
  (define-key vertico-map "?" #'minibuffer-completion-help)
  (define-key vertico-map (kbd "M-TAB") #'minibuffer-complete))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package recentf
  :init
  (defun recentf-open-files+ ()
    "Use `completing-read' to open a recent file."
    (interactive)
    (let ((files (mapcar 'abbreviate-file-name recentf-list)))
      (find-file (completing-read "Find recent file: " files nil t))))
  :config
  (recentf-mode t))

(use-package consult
  :custom
  (consult-find-command "fd -I -t f ")
  :init
  (defun consult-focus-lines-quit ()
    (interactive)
    (consult-focus-lines -1))
  :bind
  ("M-'" . consult-register-store)
  :config
  ;; (setq consult-project-root-function #'projectile-project-root)
  (setq consult-project-root-function nil)
  (defun find-fd (&optional dir initial)
    (interactive "P")
    (let ((consult-find-command "fd --color=never --full-path ARG OPTS"))
      (consult-find dir initial))))

(use-package olivetti
  :init
  ;; (setq olivetti-body-width 80)
  (setq olivetti-body-width 0.65)
  (setq olivetti-minimum-body-width 72))

(use-package vterm
  :init
  ;; (evil-define-key 'insert vterm-mode-map "C-u" 'vterm-send-C-u)
  (setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=no")
  (setq vterm-kill-buffer-on-exit t))

(use-package paren
  :config
  (show-paren-mode 1))

(use-package magit)

(use-package beacon
  :init
  (setq beacon-blink-when-window-scrolls nil)
  :config
  (beacon-mode 1)
  (setq beacon-dont-blink-major-modes (append beacon-dont-blink-major-modes
                                              '(vterm-mode shell-mode eshell-mode term-mode elfeed-show-mode)))
  (add-hook 'beacon-dont-blink-predicates
            (lambda () (bound-and-true-p org-tree-slide-mode))))

(use-package eyebrowse
  :demand t
  :custom
  (eyebrowse-wrap-around t)
  :bind
  (:map
   eyebrowse-mode-map
   ("s-1" . 'eyebrowse-switch-to-window-config-1)
   ("s-2" . 'eyebrowse-switch-to-window-config-2)
   ("s-3" . 'eyebrowse-switch-to-window-config-3)
   ("s-4" . 'eyebrowse-switch-to-window-config-4)
   ("s-5" . 'eyebrowse-switch-to-window-config-5)
   ("s-<up>" . 'eyebrowse-close-window-config)
   ("s-<down>" . 'eyebrowse-rename-window-config)
   ("s-<left>" . 'eyebrowse-prev-window-config)
   ("s-<right>" . 'eyebrowse-next-window-config))
  :hook
  ((eyebrowse-post-window-switch . get-eyebrowse-status)
   (eyebrowse-post-window-delete . get-eyebrowse-status))
  :config
  (defun get-eyebrowse-status ()
    (interactive)
    (message (eyebrowse-mode-line-indicator)))
  (eyebrowse-mode))

(use-package all-the-icons)

(use-package all-the-icons-dired
  :hook
  ((dired-mode . (lambda ()
                   (interactive)
                   (unless (file-remote-p default-directory)
                     (all-the-icons-dired-mode))))
   (deer-mode . all-the-icons-dired-mode))
  :config/el-patch
  (defun all-the-icons-dired--setup ()
    "Setup `all-the-icons-dired'."
    (setq-local tab-width (el-patch-swap 1 2))
    (pcase-dolist (`(,file ,sym ,fn) all-the-icons-dired-advice-alist)
      (with-eval-after-load file
        (advice-add sym :around fn)))
    (all-the-icons-dired--refresh)))

(use-package expand-region
  :bind
  (("C-=" . er/expand-region)
   ("C--" . er/contract-region)))


(use-package iedit)

(use-package flycheck
  :hook
  ((prog-mode . flycheck-mode)
   (emacs-lisp-mode . (lambda () (flycheck-mode -1)))))

(use-package consult-flycheck
  :bind (:map flycheck-command-map
              ("!" . consult-flycheck)))

(use-package eshell
  :init
  (defun eshell-other-window ()
    "Open a `shell' in a new window."
    (interactive)
    (let ((buf (eshell)))
      (switch-to-buffer (other-buffer buf))
      (switch-to-buffer-other-window buf)))
  :hook
  (eshell-mode . (lambda ()
                   (general-define-key
                    :keymaps 'eshell-mode-map
                    :states '(insert emacs)
                    "C-u" 'eshell-kill-input
                    "C-a" 'eshell-bol
                    "C-p" 'eshell-previous-input
                    "C-n" 'eshell-next-input)
                    (general-define-key
                    :states '(normal visual)
                    :keymaps 'eshell-mode-map
                    "`" 'beacon-blink
                    "f" 'avy-goto-word-0
                    ;;"F" 'avy-goto-char-2
                    "C-f" 'evil-avy-goto-line
                    "J" (lambda () (interactive) (scroll-up-command 1) (forward-line 1))
                    "K" (lambda () (interactive) (scroll-up-command -1) (forward-line -1))))))

(use-package org
  :hook
  (org-mode . org-indent-mode)
  :bind
  (:map org-mode-map
        ("C-c C-c" . (lambda ()
                     (interactive)
                     (org-ctrl-c-ctrl-c)
                     (org-display-inline-images))))
  :init
  (setq org-pretty-entities t)
  (setq org-image-actual-width nil)
  (require 'org-tempo) ; enable <s, <e ... abbrev
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (setq org-ellipsis " ⭭ ")
  (setq org-special-ctrl-a/e nil) ; C-e moves to before the ellipses, not after.
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-confirm-babel-evaluate nil)
  (setq org-todo-keywords
        '((sequence "TODO(t!)" "NEXT(n!)" "|" "DONE(d!)" "HOLD(h!)" "DISCARDED(D!)")))
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  :config
  (setq org-format-latex-header
        "\\documentclass{article}
        \\usepackage[usenames]{color}
        [packages]
        [default-packages]
        \\pagestyle{empty}             % do not remove
        % the settings below are copied from fullpage.sty
        \\setlength{\\textwidth}{\\paperwidth}
        \\addtolength{\\textwidth}{-3cm}
        \\setlength{\\oddsidemargin}{1.5cm}
        \\addtolength{\\oddsidemargin}{-2.54cm}
        \\setlength{\\evensidemargin}{\\oddsidemargin}
        \\setlength{\\textheight}{\\paperheight}
        \\addtolength{\\textheight}{-\\headheight}
        \\addtolength{\\textheight}{-\\headsep}
        \\addtolength{\\textheight}{-\\footskip}
        \\addtolength{\\textheight}{-3cm}
        \\setlength{\\topmargin}{1.5cm}
        \\setlength\parindent{0pt}
        \\addtolength{\\topmargin}{-2.54cm}")
  (defface org-checkbox-done-text
    '((t (:inherit 'org-headline-done)))
    "Face for the text part of a checked org-mode checkbox.")

  (font-lock-add-keywords
   'org-mod
   `(("^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?:X\\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)"
      1 'org-checkbox-done-text prepend))
   'append)
  (setq haskell-process-type 'stack-ghci)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((haskell . t)
     (ditaa . t)
     (dot . t)
     (latex . t)
     (shell . t)
     (plantuml . t)))
  (add-to-list 'org-export-backends 'md)
  (require 'org-attach)
  (require 'ob-js)
  (require 'ob-clojure)
  (setq org-babel-clojure-backend 'cider)
  (require 'cider)
  (require 'ob-scheme)
  (require 'ob-ruby))

(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-download
  :after org
  :hook
  (dired-mode . org-download-enable)
  :init
  (setq org-download-image-org-width 500)
  ;; (setq-default org-download-image-dir "note_assets")
  (setq org-download-method 'attach)
  (setq-default org-download-heading-lvl nil)
  ;; (setq org-download-method 'directory)
  (setq org-download-screenshot-method "/usr/sbin/screencapture -i %s"))

(use-package electric
  :config
  (electric-pair-mode)
  :hook
  (org-mode
   . (lambda ()
       (setq-local electric-pair-inhibit-predicate
                   `(lambda (c)
                      (if (char-equal c ?<)
                          t
                        (,electric-pair-inhibit-predicate c)))))))

(use-package hide-mode-line
  :hook
  (dired-mode . hide-mode-line-mode))

(use-package org-tree-slide
  :init
  (setq org-tree-slide-heading-emphasis t)
  :bind
  (:map org-tree-slide-mode-map
        ("s-<left>" . org-tree-slide-move-previous-tree)
        ("s-<right>" . org-tree-slide-move-next-tree)
        ("s-<up>" . org-tree-slide-content))
  :hook
  (org-tree-slide-play . (lambda ()
                           (make-local-variable 'previous-line-spacing)
                           (setq previous-line-spacing line-spacing)
                           (setq line-spacing 1.0)
                           ;; (setq line-spacing 0)
                           (org-display-inline-images)
                           (setq text-scale-mode-amount 3)
                           (text-scale-mode)
                           (hide-mode-line-mode)))
  (org-tree-slide-stop . (lambda ()
                           (setq line-spacing previous-line-spacing)
                           (text-scale-mode -1)
                           (hide-mode-line-mode -1)))
  :config
  (org-tree-slide-simple-profile))

(use-package winner
  :config
  (winner-mode +1))

(use-package consult-dir
  :straight (:type git :host github :repo "karthink/consult-dir")
  :bind (("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)))

;; Colorize hex code
(use-package rainbow-mode
  :config
  (rainbow-mode))

(use-package fireplace)

(use-package snow
  :straight (snow :host github :repo "alphapapa/snow.el"))

(use-package helpful
    :general
    (:keymaps 'override
              :states '(normal insert emacs visual)
              "C-h f" #'helpful-callable
              "C-h v" #'helpful-variable
              "C-h k" #'helpful-key
              ;; "C-c C-d" #'helpful-at-point
              "C-h F" #'helpful-function
              "C-h C" #'helpful-command))

(use-package ace-link
  :general
  (:keymaps '(Info-mode-map
              help-mode-map
              woman-mode-map
              eww-mode-map
              compilation-mode-map
              helpful-mode-map
              org-mode-map
              elfeed-show-mode-map
              mu4e-view-mode-map)
            :states 'normal
            "F" 'ace-link))

(use-package elisp-demos
  :config
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

(use-package sicp)

(use-package popper
  :bind (("s-p"   . popper-toggle-latest)
         ("s-P"   . popper-cycle)
         ("s-C-p" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("^\\*Messages\\*"
          "^\\*cider"
          "^\\*vterm\\*"
          "^\\*skewer-repl\\*"
          "[Oo]utput\\*"
          "^\\*Compile-Log\\*"
          "^\\*Backtrace\\*"
          "^Calc:"
          "^\\*ielm\\*"
          "^\\*Completions\\*"
          "^\\*Async Shekk Command\\*"
          "^\\*Shell Command Output\\*"
          "^\\*TeX Help\\*"
          "^\\*Apropos"
          "^\\*evil-registers\\*"
          eshell-mode
          helpful-mode
          help-mode
          compilation-mode))
  (defun my/popper-select-popup-at-bottom (buffer &optional _alist)
    "Display and switch to popup-buffer BUFFER at the bottom of the screen."
    (let ((window (display-buffer-in-side-window
                   buffer
                   '((window-height . (lambda (win)
                                        (fit-window-to-buffer
                                         win
                                         (floor (frame-height) 3)
                                         (floor (frame-height) 3))))
                     (side . bottom)
                     (slot . 1)))))
      (select-window window)))
  (setq popper-mode-line nil)
  (setq popper-group-function nil)
  ;; (setq popper-group-function #'popper-group-by-directory)
  ;; (setq popper-group-function #'popper-group-by-project)
  (setq popper-display-function #'my/popper-select-popup-at-bottom)
  (popper-mode +1))

(use-package fold-this)

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect-first nil)    ;; Disable candidate preselection
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-echo-documentation nil) ;; Disable documentation in the echo area
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; You may want to enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since dabbrev can be used globally (M-/).
  :init
  ;; (setq corfu-auto t
  ;;     corfu-quit-no-match 'separator) ;; or t
  (corfu-global-mode))

(use-package cape
  ;; Bind dedicated completion commands
  :bind (("C-c p p" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-symbol)
         ("C-c p a" . cape-abbrev)
         ("C-c p i" . cape-ispell)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p \\" . cape-tex)
         ("M-l" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-ispell)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  )

(use-package which-key
  :config
  (which-key-mode))

(use-package svg-lib)

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  (kind-icon-use-icons nil)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package unicode-math-input)

(use-package ligature
  :straight (:host github :repo "mickeynp/ligature.el")
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))
