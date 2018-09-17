(setq package-archives
  '(("melpa" . "http://melpa.org/packages/")
    ("gnu"   . "http://elpa.gnu.org/packages/")))
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(autoload 'apache-mode "apache-mode" nil t)
(require 'php-mode)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq-default org-catch-invisible-edits 'smart
	      line-move-visual nil
)
(setq inhibit-startup-message t
      backup-directory-alist '(("." . "~/.saves"))
      sh-basic-offset 2
      sh-indentation 2
      smie-indent-basic 2
      org-src-fontify-natively t)
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
 '(custom-enabled-themes (quote (misterioso)))
 '(org-confirm-babel-evaluate nil)
 '(org-export-with-sub-superscripts (quote {}))
 '(package-selected-packages (quote (json-mode htmlize php-mode apache-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))

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

