;; .emacs.d/init.el

;; ===================================
;; Custom variables
;; ===================================

(defvar myBackupDirectory "/my/backup/path")

; myPackages contains a list of package names
(defvar myPackages
  '(material-theme                  ;; Theme
    ;better-defaults                ;; Changed defaults for Emacs. Should be added to own file instead
    elpy                            ;; Emacs Lisp Python Environment
    php-mode                        ;; Major mode for PHP
    web-mode                        ;; Mode for web files
    dockerfile-mode                 ;; Mode for Dockerfiles
    docker-compose-mode             ;; Mode for docker compose
    lsp-mode                        ;; General LSP mode
    lsp-latex                       ;; LSP mode for LaTeX
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
; Enable elpy
(elpy-enable)

; Might need to run elpy-rpc-reinstall-virtualenv
; Make sure to install virtualenv!
(setq
      python-shell-interpreter "python3"
      python-shell-interpreter-args "-i"
      elpy-rpc-python-command "python3"
      )

; Function to enable yas minor mode
(defun my-enable-yas-minor-mode ()
  (yas-minor-mode 1))

(with-eval-after-load "tex-mode"
 (add-hook 'tex-mode-hook 'lsp)
 (add-hook 'latex-mode-hook 'lsp)
 (add-hook 'tex-mode-hook 'my-enable-yas-minor-mode)
 (add-hook 'latex-mode-hook 'my-enable-yas-minor-mode))


;; ====================================
;; User-Defined init.el ends here
;; ====================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(elpy material-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
