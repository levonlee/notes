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

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(unless package-archive-contents
  (package-refresh-contents))


(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq-default org-catch-invisible-edits 'smart
	      line-move-visual nil
	      org-list-indent-offset 1
	      frame-title-format "%b <%f>"
	      tab-width 4)
(setq inhibit-startup-message t
      backup-directory-alist '(("." . "~/.saves"))
      sh-basic-offset 2
      sh-indentation 2
      smie-indent-basic 2
      org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-startup-folded t)
;; Turn off some unneeded UI elements
(menu-bar-mode -1)  ; Leave this one on if you're a beginner!
(tool-bar-mode -1)
(scroll-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(auto-save-visited-mode t)
 '(column-number-mode t)
 '(gnutls-algorithm-priority "normal:-vers-tls1.3")
 '(help-window-select t)
 '(org-adapt-indentation nil)
 '(org-confirm-babel-evaluate nil)
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(org-export-with-sub-superscripts '{})
 '(org-goto-interface 'outline-path-completion)
 '(org-list-allow-alphabetical t)
 '(package-selected-packages
   '(expand-region docker-compose-mode graphql-mode web-mode dockerfile-mode nginx-mode yaml-mode json-mode htmlize php-mode apache-mode))
 '(python-indent-guess-indent-offset nil))

;; Configure the Modus Themes' appearance https://protesilaos.com/emacs/modus-themes
;; Fallback to misterioso in custom-set-variables '(custom-enabled-themes '(misterioso))
(setq modus-themes-mode-line '(accented borderless)
      modus-themes-bold-constructs t
      modus-themes-italic-constructs t
      modus-themes-fringes 'subtle
      modus-themes-tabs-accented t
      modus-themes-paren-match '(bold intense)
      modus-themes-prompts '(bold intense)
      modus-themes-org-blocks 'tinted-background
      modus-themes-region '(bg-only)
      modus-themes-headings
      '((1 . (rainbow regular 1.5))
        (2 . (rainbow regular 1.4))
        (3 . (rainbow regular 1.3))
        (4 . (rainbow regular 1.2))
        (5 . (rainbow regular 1.12))
        (t . (rainbow regular 1.1)))
)

;; Load the dark theme by default
(load-theme 'modus-vivendi-tinted t)

(package-install-selected-packages)

(autoload 'apache-mode "apache-mode" nil t)
(require 'php-mode)
;; (add-hook 'php-mode-hook '(lambda ()
;;                            (setq c-basic-offset 2
;;                                  tab-width 2
;;                                  indent-tabs-mode t)
;;                            ))
(require 'web-mode)
(define-derived-mode web-php-mode web-mode "WebPhp"
  "Major mode for editing web php templates."
  (web-mode)
  (web-mode-set-engine "php"))
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 130 :width normal)))))

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

;; use visual bell
(defun my-terminal-visible-bell ()
   "A friendlier visual bell effect."
   (invert-face 'mode-line)
   (run-with-timer 0.1 nil 'invert-face 'mode-line))

 (setq visible-bell nil
       ring-bell-function 'my-terminal-visible-bell)

;; display outline path of hierarchical headings
(defun lili-show-path ()
  (interactive)
  (message (mapconcat #'identity (org-get-outline-path t) "/")))
