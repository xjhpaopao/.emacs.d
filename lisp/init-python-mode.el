(autoload 'doctest-mode "doctest-mode" "Python doctest editing mode." t)

(setq interpreter-mode-alist
      (cons '("python" . python-mode) interpreter-mode-alist))


;;----------------------------------------------------------------------------
;; On-the-fly syntax checking via flymake
;;----------------------------------------------------------------------------
(eval-after-load 'python
  '(require 'flymake-python-pyflakes))

(add-hook 'python-mode-hook
          '(lambda ()
             (unless (is-buffer-file-temp)
               (message "python-mode-hook called")
               (when *emacs24*
                 (anaconda-mode)
                 (add-to-list 'company-backends 'company-anaconda)
                 (eldoc-mode))
               (if (executable-find "pyflakes")
                   (flymake-python-pyflakes-load))
               )))

(provide 'init-python-mode)
