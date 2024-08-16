;; ===================================
;; Necessary one-time function calls
;; ===================================

; Ensure virtualenv is in place
(elpy-rpc-reinstall-virtualenv)

; Install language server for omnisharp
(mnisharp-install-server)
