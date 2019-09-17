(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "http")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(autoload 'apache-mode "apache-mode" nil t)
(require 'php-mode)
(require 'web-mode)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq-default org-catch-invisible-edits 'smart
	      line-move-visual nil
	      org-list-indent-offset 1
)
(setq inhibit-startup-message t
      backup-directory-alist '(("." . "~/.saves"))
      sh-basic-offset 2
      sh-indentation 2
      smie-indent-basic 2
      org-src-fontify-natively t
      org-src-tab-acts-natively t)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(add-hook 'php-mode-hook '(lambda ()
                            (setq c-basic-offset 2
                                  tab-width 2
                                  indent-tabs-mode t)
                            ))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (misterioso)))
 '(org-confirm-babel-evaluate nil)
 '(org-export-with-sub-superscripts (quote {}))
 '(package-selected-packages
   (quote
    (gitignore-mode web-mode dockerfile-mode nginx-mode yaml-mode json-mode htmlize php-mode apache-mode))))

(define-derived-mode web-php-mode web-mode "WebPhp"
  "Major mode for editing web php templates."
  (web-mode)
  (web-mode-set-engine "php"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 98 :width normal)))))

;; Change the export directory from root to sub directory docs so that GitHub can pick up
(defun org-export-output-file-name-modified (orig-fun extension &optional subtreep pub-dir)
  (unless pub-dir
    (setq pub-dir "docs")
    (unless (file-directory-p pub-dir)
      (make-directory pub-dir)))
  (apply orig-fun extension subtreep pub-dir nil))
(advice-add 'org-export-output-file-name :around #'org-export-output-file-name-modified)

;; Add dot language to org-babel
(org-babel-do-load-languages
'org-babel-load-languages
'((dot . t)))

