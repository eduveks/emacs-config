
;; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Show only one active window when opening multiple files at the same time.
(add-hook 'window-setup-hook 'delete-other-windows)

;; No more typing the whole yes or no. Just y or n will do.
(fset 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-screen t)

(setq initial-buffer-choice ".")

(setq create-lockfiles nil)

(global-set-key (kbd "M-9") 'kill-whole-line)

(defun duplicate-line ()
  "EASY"
  (interactive)
  (save-excursion
    (let ((line-text (buffer-substring-no-properties
                      (line-beginning-position)
                      (line-end-position))))
      (move-end-of-line 1)
      (newline)
      (insert line-text))))
(global-set-key "\C-cd" 'duplicate-line)

(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))
(global-set-key [f12] 'indent-buffer)

(setq-default indent-tabs-mode nil)

(windmove-default-keybindings)

(ido-mode 1)
(setq ido-separator "\n")
(setq ido-enable-flex-matching t)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap 'use-package'
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(coffee-tab-width 2)
 '(jdee-jdk
   (quote "~/netuno/graalvm"))
 '(jdee-server-dir "~/.emacs.d/jdee-server/dist")
 '(package-selected-packages
   (quote
    (whitespace-mode coffee-mode swift-mode jdee kaolin-themes fiplr company-emoji bash-completion auto-complete move-text drag-stuff kotlin-mode markdown-mode php-mode lusty-explorer rjsx-mode web-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'use-package)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(require 'fiplr)
(setq fiplr-root-markers '(".git"))
(setq fiplr-ignored-globs '((directories (".git" "node_modules"))
                            (files ("*.log" "*.tmp" "*~"))))
(global-set-key (kbd "C-x f") 'fiplr-find-file)

(require 'rjsx-mode)
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("src\\/.*\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("website\\/pages\\/.*\\.js\\'" . rjsx-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
(add-hook 'web-mode-hook
    (lambda ()
      (when (string-equal "tsx" (file-name-extension buffer-file-name))
	(setup-tide-mode))))
(add-hook 'web-mode-hook
    (lambda ()
      (when (string-equal "ts" (file-name-extension buffer-file-name))
	(setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

(autoload 'markdown-mode "markdown-mode"
	     "Major mode for editing Markdown files" t)
(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))

(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.coffee\\'" . coffee-mode))

(require 'swift-mode)
(add-to-list 'auto-mode-alist '("\\.swift\\'" . swift-mode))

(require 'bash-completion)
(bash-completion-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://gitlab.com/skybert/my-little-friends/-/blob/master/emacs/.emacs
(use-package company
  :init
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))
(global-company-mode 1)
(global-set-key (kbd "<C-return>") 'company-complete)
(use-package company-emoji)
(add-to-list 'company-backends 'company-emoji)

;; automatically clean up bad whitespace
(setq whitespace-action '(auto-cleanup))
;; only show bad whitespace
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab))

;(require 'auto-complete)
;(ac-config-default)

;(require 'company)
;(add-hook 'after-init-hook 'global-company-mode)

;(move-text-default-bindings)

(electric-indent-mode -1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;;(require 'kaolin-themes)
;;(load-theme 'kaolin-valley-dark t)
;; Apply treemacs customization for Kaolin themes, requires the all-the-icons package.
;;(kaolin-treemacs-theme)

(put 'upcase-region 'disabled nil)