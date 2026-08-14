;; .emacs.d/init.el

;; ===================================
;; Custom variables
;; ===================================

(defvar myBackupDirectory "/my/backup/path")
(defvar myExtraPackagesDirectory "/my/extra/code/path")

;; ===================================
;; MELPA Package Support
;; ===================================
; Enables basic packaging support
(require 'package)

; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

; Initializes the package infrastructure
(package-initialize)

; If there are no archived package contents, refresh them
(unless package-archive-contents
  (package-refresh-contents))

;; ===================================
;; use-package based installs
;; ===================================

; use-package require
(require 'use-package)
(setq use-package-always-ensure t)

; Material theme
(use-package material-theme
  :config
  (load-theme 'material t)
)

; Yasnippet - snippet management library
(use-package yasnippet
  :config
  (yas-reload-all)
  :hook
  (
   (python-mode tex-mode latex-mode) . yas-minor-mode
  )
)

; Yasnippet snippets - premade snippets
(use-package yasnippet-snippets
  :after
  yasnippet
  )

; Ruff format - Formatter for Python
(use-package ruff-format
  :hook
  (python-mode . ruff-format-on-save-mode)
)

; Flymake Ruff - Python linter
(use-package flymake-ruff
  :hook (python-mode . flymake-ruff-load)
)

; PHP mode
(use-package php-mode)

; Web mode
(use-package web-mode)

; Dockerfile mode
(use-package dockerfile-mode
  :mode
  "Dockerfile\\'"
)

; Docker-compose mode
(use-package docker-compose-mode
  :mode
  "docker-compose.*\\.ya?ml\\'"
)

; Company mode - GUI for lsp-mode completion
(use-package company
  :hook
  (prog-mode . company-mode)
  :custom
  (company-idle-delay 0.1) ; How quickly completions appear after typing
  (company-minimum-prefix-length 1) ; Trigger after a single character
  (company-tooltip-align-annotations t) ; Line up annotations (types, modules) neatly
)

; LSP mode - Provides LSP-based completions
(use-package lsp-mode
  :hook
  ((python-mode tex-mode latex-mode) . lsp) ; Extend this list as more LSP support is added to this config
  :custom
  (lsp-completion-provider :capf)
  :config
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("ty" "server"))
    :major-modes '(python-mode)
    :server-id 'ty
    :priority -1
    )
   )
  )
)

; LSP Latex - LSP support for TeX documents
(use-package lsp-latex
  :after
  lsp-mode
)

;; ===================================
;; Extra Package Support
;; ===================================
; Load extra packages
(add-to-list 'load-path myExtraPackagesDirectory)

; Include googledocstring.el
(require 'googledocstrings)

;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)     ;; Hide the startup message
(global-display-line-numbers-mode t)                ;; Enable line numbers globally
(desktop-save-mode t)                ;; Save session
(setq visible-bell t)                ;; Mute bell
(delete-selection-mode t)            ;; Always delete selection 

;; ===================================
;; Advanced Customization
;; ===================================

; Set backup location
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    `(("." . ,myBackupDirectory))    ; don't litter my fs tree
   auto-save-file-name-transforms
    `((".*" ,myBackupDirectory t))
   delete-old-versions t
   kept-new-versions 1
   kept-old-versions 3
   version-control t)       ; use versioned backups

; Delete old backup files
(message "Deleting old backup files...")
(let ((week (* 60 60 24 7))
      (current (float-time (current-time))))
  (dolist (file (directory-files temporary-file-directory t))
    (when (and (backup-file-name-p file)
               (> (- current (float-time (nth 4 (file-attributes file))))
                  week))
      (message "%s" file)
      (delete-file file))))

;; ====================================
;; Development Setup
;; ====================================

;; ====================================
;; Custom Functions
;; ====================================

;; ====================================
;; User-Defined init.el ends here
;; ====================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(company material-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
