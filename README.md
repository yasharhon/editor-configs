# emacs-init
A convenient repo containing my init file for emacs

## Requirements
* `virtualenv`

## Instructions
To set up your Emacs installation, do the following:

1. Copy the file `init.el` into your `emacs.d` directory.
2. Edit it to set the `myBackupDirectory` variable.
3. Start Emacs.
4. Run `M-x load-file RET <path to this repo>/init-first-time.el` to run a set of one-time commands.
5. Open the file `interactive-commands.txt`. Run each command in this file using `M-x <line> RET`.
