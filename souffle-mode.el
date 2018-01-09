;;; souffle-mode.el --- Major mode for Souffle datalog files. -*- lexical-binding: t -*-

;; Copyright (C) 2017 Erik Post

;; Author   : Erik Post <erik@shinsetsu.nl>
;; Homepage : https://github.com/epost/souffle-mode
;; Version  : 0.1.0
;; Keywords : languages

;;; Commentary:

;; Emacs integration for Souffle datalog files

;;; Code:

(defvar souffle-mode-hook nil)

(defvar souffle-tab-width 4)

(defconst souffle-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23" table)
    (modify-syntax-entry ?\n "> b" table)
    table))

(setq souffle-highlights
      '((":-\\|=\\|:\\|\\[\\|\\]\\|\\.type\\|\\.decl\\|\\.comp\\|\\.init\\|\\." . font-lock-keyword-face)
        ("\\number\\|symbol" . font-lock-builtin-face)
        (":" . font-lock-constant-face)))

(defun souffle-mode ()
  "Major mode for editing Workflow Process Description Language files"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table souffle-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults) '(souffle-highlights))
  (set (make-local-variable 'indent-line-function) 'souffle-indent-line)
  (setq major-mode 'souffle-mode)
  (setq-local comment-start "\/\/")
  (setq-local comment-end "")
  (setq mode-name "SOUFFLE")
  (run-hooks 'souffle-mode-hook))

(defun souffle-indent-line ()
  "Indent the current line"
  (interactive)
  (beginning-of-line)
  (if (looking-at "^[ \t]*$") ; No indetation for an empty line
      (indent-line-to 0)
    (if (looking-at "^[ \t]*\\(\\.decl\\|\\.type\\|\\.init\\|\\.comp\\|#\\)")
	(indent-line-to 0)
      (if (looking-at "^[ \t]*\\(//\\|/\\*\\)")
	  (indent-line-to 0)
	(let ((not-indented t)
	      (cur-indent 0))
	  (save-excursion
	    (while not-indented ; Iterate backwards until we find an indentation hint
	      (forward-line -1)
	      (if (looking-at "^[ \t]*\\(\\.|\\.decl\\|\\.type\\|\\.comp\\|\\.init\\|#include\\)")
		  (progn
		    (setq cur-indent (current-indentation))
		    (setq not-indented nil))
		(if (looking-at "^.*:-.*")
		    (progn
		      (setq cur-indent souffle-tab-width)
		      (setq not-indented nil))
		  (if (looking-at "^[ \t]*/\\*")
		      (progn
			(setq cur-indent 0)
			(setq not-indented nil))
		    )))))
	  (if cur-indent
	      (indent-line-to cur-indent)
	    (indent-line-to 0)))))))

(provide 'souffle)
