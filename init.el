;; .emacs.d/init.el

;; ===================================
;; MELPA Package Support
;; ===================================
;; Enables basic packaging support
(require 'package)

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Initializes the package infrastructure
(package-initialize)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(;;better-defaults                 ;; Set up some better Emacs defaults
    ;;material-theme                  ;; Theme
    elpy                              ;; Emacs Lisp Python Environment
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; ===================================
;; Basic Customization
;; ===================================

;(setq inhibit-startup-message t)    ;; Hide the startup message
;(load-theme 'material t)            ;; Load material theme
(global-linum-mode t)                ;; Enable line numbers globally
(desktop-save-mode 1)                ;; Save session
(setq visible-bell 1)                ;; Mute bell
(delete-selection-mode 1)            ;; Always delete selection 

;; ===================================
;; Advanced Customization
;; ===================================

;; (backup-directory-alist (quote (("." . "/mnt/54A09841A0982B8C/Documents/Backup")))) ;; Store backupfiles in specific directory

;; Set backup location
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "/mnt/54A09841A0982B8C/Emacs/Backup"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 1
   kept-old-versions 3
   version-control t)       ; use versioned backups

;; ====================================
;; Development Setup
;; ====================================
;; Enable elpy
(elpy-enable)

(setq python-shell-interpreter "/usr/bin/python3"
      python-shell-interpreter-args "-i")

(setq elpy-rpc-python-command "python3")

;; User-Defined init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(elpy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
