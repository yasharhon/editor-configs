;; .emacs.d/init.el

;; ===================================
;; Custom variables
;; ===================================

(defvar myBackupDirectory "/my/backup/path")
(defvar myExtraPackagesDirectory "/my/extra/code/path")

; myPackages contains a list of package names
(defvar myPackages
  '(material-theme                  ;; Theme
    ;better-defaults                ;; Changed defaults for Emacs. Should be added to own file instead
    php-mode                        ;; Major mode for PHP
    web-mode                        ;; Mode for web files
    dockerfile-mode                 ;; Mode for Dockerfiles
    docker-compose-mode             ;; Mode for docker compose
    lsp-mode                        ;; General LSP mode
    lsp-latex                       ;; LSP mode for LaTeX
    company                         ;; Completion UI
    reformatter                     ;; Needed for Ruff formatting
    ruff-format                     ;; Provides formatting with Ruff
    flymake-ruff                    ;; Flymake-based Ruff linting
    yasnippet                       ;; Snippet templating system
    yasnippet-snippets              ;; Snippet library
    )
  )

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
(when (not package-archive-contents)
  (package-refresh-contents))

; Installs packages by scanning the list in myPackages
; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; ===================================
;; Extra Package Support
;; ===================================
; Load extra packages
(add-to-list 'load-path myExtraPackagesDirectory)

; Include googledocstring.el
(require 'googledocstrings)

;; ===================================
;; File mode associations
;; ===================================

(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
(add-to-list 'auto-mode-alist '("docker-compose" . docker-compose-mode))

;; ===================================
;; Basic Customization
;; ===================================

(setq inhibit-startup-message t)     ;; Hide the startup message
(load-theme 'material t)             ;; Load material theme
(global-display-line-numbers-mode 1)                ;; Enable line numbers globally
(global-display-line-numbers-mode t)                ;; Enable line numbers globally
(desktop-save-mode 1)                ;; Save session
(setq visible-bell 1)                ;; Mute bell
(delete-selection-mode 1)            ;; Always delete selection 

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
               (> (- current (float-time (fifth (file-attributes file))))
                  week))
      (message "%s" file)
      (delete-file file))))

;; ====================================
;; Development Setup
;; ====================================
; Function to enable yas minor mode
(defun my-enable-yas-minor-mode ()
  (yas-minor-mode 1))

; Activate yasnippet
(require 'yasnippet)

; Load snippets
(yas-reload-all)

(with-eval-after-load "tex-mode"
 (add-hook 'tex-mode-hook 'lsp)
 (add-hook 'latex-mode-hook 'lsp)
 (add-hook 'tex-mode-hook 'my-enable-yas-minor-mode)
 (add-hook 'latex-mode-hook 'my-enable-yas-minor-mode))

; Register ty as LSP client in Python mode
(with-eval-after-load 'lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("ty" "server"))
    :major-modes '(python-mode)
    :server-id 'ty
    :priority -1)))

; Start LSP when entering Python mode
(add-hook 'python-mode-hook #'lsp)

; Company mode configuration
;; How quickly completions appear after typing
(setq company-idle-delay 0.1
      ;; Trigger after a single character
      company-minimum-prefix-length 1
      ;; Line up annotations (types, modules) neatly
      company-tooltip-align-annotations t)

;; Tell lsp-mode to provide completions via completion-at-point (CAPF)
;; company consumes CAPF when active
(setq lsp-completion-provider :capf)

; Start company when entering Python mode
(add-hook 'python-mode-hook #'company-mode)

; Format on save with Ruff
(add-hook 'python-mode-hook 'ruff-format-on-save-mode)

; Lint Python files with Ruff
(add-hook 'python-mode-hook #'flymake-ruff-load)

; Load snippets in Python mode
(add-hook 'python-mode-hook #'yas-minor-mode)

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
