;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Marvin Kohl"
      user-mail-address "marvin.kohl@posteo.de")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Hack" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; F7 - F9 -- reserved for user
(map! "<f7>" 'eshell)

;; When pass all keys to emacs, at least allow switch-activity
(require 'dbus)
(defun my-switch-activity ()
  "Switch the kde activty."
  (interactive)
  (cl-flet ((call (method &rest args)
                  (apply 'dbus-call-method
                         (append `(:session
                                   "org.kde.ActivityManager"
                                   "/ActivityManager/Activities"
                                   "org.kde.ActivityManager.Activities"
                                   ,method)
                                 args))))
    (call "SetCurrentActivity"
          (car (remove (call "CurrentActivity")
                       (call "ListActivities"))))))

;; Use ace-jump-mode
(use-package! ace-jump-mode
  :config
  (map! "C-c SPC" #'ace-jump-mode
        "C-c j" #'ace-jump-mode
        (:leader "j" #'ace-jump-mode)))

(map! :n "ZM" #'suspend-frame)

(add-hook! lisp-mode
  (turn-on-smartparens-strict-mode)
  (sp-use-smartparens-bindings))

(add-hook! markdown-mode
  (turn-on-auto-fill))

(defun my-transpose-windows ()
  "Interchanges the two open windows."
  (interactive)
  (unless (= 2 (count-windows))
    (error "Es sind nicht zwei Fenster vorhanden."))
  (let ((windows (window-list)))
    (rotatef (window-buffer (first windows))
             (window-buffer (second windows)))))

;; Set prolog as default for .pl files
(add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

(defun my-prolog-run-tests ()
  "Run Prolog Tests."
  (interactive)
  (let ((prolog-run-tests-string "run_tests.\n"))
    (prolog-process-insert-string (get-process "prolog") prolog-run-tests-string)
    (process-send-string "prolog" prolog-run-tests-string)))

(use-package! prolog
  :config
  (set-popup-rules!
    '(("^\\*prolog\\*$")))

  (map! (:localleader
         :map prolog-mode-map
         "/" #'prolog-help-apropos
         "?" #'prolog-help-on-predicate
         "a" #'align
         "b" #'prolog-consult-buffer
         "c b" #'prolog-compile-buffer
         "c f" #'prolog-compile-file
         "c p" #'prolog-compile-predicate
         "c r" #'prolog-compile-region
         "d" #'prolog-debug-on
         "f" #'prolog-consult-file
         "l" #'prolog-consult-file
         "n" #'prolog-insert-predicate-template
         "p" #'prolog-consult-predicate
         "r" #'prolog-consult-region
         "s" #'prolog-insert-predspec
         "t" #'prolog-trace-on
         "u" #'my-prolog-run-tests
         "v s" #'prolog-view-predspec
         "v a" #'prolog-variables-to-anonymous
         "z" #'run-prolog
         "RET" #'run-prolog)))
