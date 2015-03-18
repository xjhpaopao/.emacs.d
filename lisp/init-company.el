(add-hook 'prog-mode-hook 'global-company-mode)
(add-hook 'cmake-mode-hook 'global-company-mode)

(setq company-require-match nil)
;; press SPACE will accept the highlighted candidate and insert a space
;; `M-x describe-variable company-auto-complete-chars` for details
;; That's BAD idea.
(setq company-auto-complete nil)

(if (fboundp 'evil-declare-change-repeat)
    (mapc #'evil-declare-change-repeat
          '(company-complete-common
            company-select-next
            company-select-previous
            company-complete-selection
            company-complete-number
            )))

(eval-after-load 'company
  '(progn
     (add-to-list 'company-backends 'company-cmake)
     (add-to-list 'company-backends 'company-c-headers)
     ;; can't work with TRAMP
     (setq company-backends (delete 'company-ropemacs company-backends))
     ;; (setq company-backends (delete 'company-capf company-backends))
     ;; I don't like the downcase word in company-dabbrev
     ;; for languages use camel case naming convention
     (setq company-dabbrev-downcase nil)
     (setq company-show-numbers t)
     (setq company-begin-commands '(self-insert-command))
     (setq company-idle-delay 0.2)
     (setq company-clang-insert-arguments nil)
     ))
;; change the default color to better view in the dark background
(deftheme jellybeans
    "Created 2013-11-05.")

(custom-theme-set-faces
  'jellybeans
   '(cursor ((t (:background "#b0d0f0"))))

    '(default ((t (:inherit nil :background "#151515" :foreground "#e8e8d3"))))

     ;; company
     '(company-tooltip ((t (:background "#606060")))))

(provide 'init-company)
