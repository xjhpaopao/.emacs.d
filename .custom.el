;;Customized configuration
;;
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
(custom-set-faces
 '(window-numbering-face ((t (:foreground "DeepPink" :underline "DeepPink" :weight bold))) t))
;;; Local Variables:
;;; no-byte-compile: t
;;; End:
(put 'erase-buffer 'disabled nil)
;;Copy without selection
(defun get-point (symbol &optional arg)
  "get the point"
  (funcall symbol arg)
  (point)
  )
(defun copy-thing (begin-of-thing end-of-thing &optional arg)
  "copy thing between beg & end into kill ring"
  (save-excursion
    (let ((beg (get-point begin-of-thing 1))
          (end (get-point end-of-thing arg)))
      (copy-region-as-kill beg end)))
  )
(defun paste-to-mark(&optional arg)
  "Paste things to mark, or to the prompt in shell-mode"
  (let ((pasteMe
         (lambda()
           (if (string= "shell-mode" major-mode)
               (progn (comint-next-prompt 25535) (yank))
             (progn (goto-char (mark)) (yank) )))))
    (if arg
        (if (= arg 1)
            nil
          (funcall pasteMe))
      (funcall pasteMe))
    ))
;;;copy word
(defun copy-word (&optional arg)
  "Copy words at point into kill-ring"
  (interactive "P")
  (copy-thing 'backward-word 'forward-word arg)
  ;;(paste-to-mark arg)
  )
;;;copy Line
(defun copy-line (&optional arg)
  "Save current line into Kill-Ring without mark the line "
  (interactive "P")
  (copy-thing 'beginning-of-line 'end-of-line arg)
  ;(paste-to-mark arg)
  )
;;;copy paragraph
(defun copy-paragraph (&optional arg)
  "Copy paragraphes at point"
  (interactive "P")
  (copy-thing 'backward-paragraph 'forward-paragraph arg)
  ;(paste-to-mark arg)
  )
;;;copy string
(defun beginning-of-string(&optional arg)
  "  "
  (re-search-backward "[ \t]" (line-beginning-position) 3 1)
  (if (looking-at "[\t ]")  (goto-char (+ (point) 1)) )
  )
(defun end-of-string(&optional arg)
  " "
  (re-search-forward "[ \t]" (line-end-position) 3 arg)
  (if (looking-back "[\t ]") (goto-char (- (point) 1)) )
  )

(defun thing-copy-string-to-mark(&optional arg)
  " Try to copy a string and paste it to the mark
     When used in shell-mode, it will paste string on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-string 'end-of-string arg)
  ;(paste-to-mark arg)
  )
;;bind helm-find-file as the default
;;bind helm-M-x as the default

;;chose the color theme
(require 'color-theme-molokai)
(color-theme-molokai)
;;Highlight the current line
;;(global-hl-line-mode t)

;;yasnippet with emacs
(require 'yasnippet)
(yas-global-mode)
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers))
;now let's call this function from c/c++ hooks
;(add-hook 'c++-mode-hook 'my:ac-c-header-init)
;(add-hook 'c-mode-hook 'my:ac-c-header-init)

;add fun to init flymake
(defun my:flymake-google-init ()
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/bin/cpplint"))
  (flymake-google-cpplint-load)
  )
(add-hook 'c++-mode-hook 'my:flymake-google-init)
(add-hook 'c-mode-hook 'my:flymake-google-init)

(defun my:helm-gtags-init ()
  (helm-gtags-mode 1)
  )
(add-hook 'c++-mode-hook 'my:helm-gtags-init)
(add-hook 'c++-mode-hook 'my:helm-gtags-init)

;;projectile configuration
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;auto complete configuration
(setq company-c-headers-path-user 'projectile-get-project-directories)
(require 'cc-mode)
;(define-key c-mode-map [(tab)] 'company-clang)
;(define-key c++-mode-map [(tab)] 'company-clang)

;function-args
(require 'function-args)
(fa-config-default)

;;search current word
(define-key isearch-mode-map (kbd "C-*")
  (lambda ()
    "Reset current isearch to a word-mode search of the word under point."
    (interactive)
    (setq isearch-word t
          isearch-string ""
          isearch-message "")
    (isearch-yank-string (word-at-point))))

;;; set mic-paren
(require 'mic-paren)
(paren-activate)

;turn on sematic
;(global-semanticdb-minor-mode 1)
;(global-semantic-idle-scheduler-mode 1)
;(semantic-mode 1)
;add sematic to auto complete
;(defun my:add-sematic-to-auto-complete ()
;  (add-to-list 'ac-sources 'ac-source-semantic))
;(add-hook 'c-mode-common-hook 'my:add-sematic-to-auto-complete)

;turn on ede mode
;(global-ede-mode 1)
;create project
;(ede-cpp-root-project "demo project" :file "~/temp.cpp"
;		      :included-path '("/../my_inc"))

(add-to-list 'load-path "~/tools/orgmode/org-mode/lisp")
(add-to-list 'load-path "~/tools/orgmode/org-mode/contrib/lisp" t)
;compile helper
(global-set-key (kbd "<f7>")
                (lambda ()
                  (interactive)
                  (setq-local compilation-read-command nil)
                  (call-interactively 'compile)))
;Cpputils-make
(add-hook 'c-mode-common-hook
          (lambda ()
            (if (derived-mode-p 'c-mode 'c++-mode)
                (cppcm-reload-all))))
;; OPTIONAL, somebody reported that they can use this package with Fortran
(add-hook 'c90-mode-hook (lambda () (cppcm-reload-all)))
;;special for windows. projectile indexing
(if *win32* (setq projectile-indexing-method 'alien))

;gdb setting
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t
 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t)
(global-set-key (kbd "<f5>")
                (lambda ()
                  (interactive)
                  (call-interactively 'gdb)))

;; OPTIONAL, avoid typing full path when starting gdb
(global-set-key (kbd "C-c C-g")
                '(lambda () (interactive) (gud-gdb (concat "gdb --fullname " (cppcm-get-exe-path-current-buffer)))))
;; OPTIONAL, some users need specify extra flags forwarded to compiler
(setq cppcm-extra-preprocss-flags-from-user '("-I/usr/src/linux/include" "-DNDEBUG"))
;;global bind
(global-set-key (kbd "C-x C-o") 'ff-find-other-file)
(global-set-key (kbd "C-c i") 'iedit-mode)
(global-set-key (kbd "C-c s") (quote thing-copy-string-to-mark))
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c p") (quote copy-paragraph))
(global-set-key (kbd "C-c l") (quote copy-line))
(global-set-key (kbd "C-c w") (quote copy-word))
(jump-quick-default-keybinding)
