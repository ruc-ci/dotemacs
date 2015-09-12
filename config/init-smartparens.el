(defgroup dotemacs-smartparens nil
  "Configuration options for smartparens."
  :group 'dotemacs
  :prefix 'dotemacs-smartparens)

(defcustom dotemacs-smartparens/autoinsert nil
  "When non-nil, turn on smartparens auto pairing instead of the default Emacs electric-pair-mode."
  :type 'boolean
  :group 'dotemacs-smartparens)

(defcustom dotemacs-smartparens/show-paren nil
  "When non-nil, turn on smartparens paren matching instead of the default Emacs show-paren-mode."
  :type 'boolean
  :group 'dotemacs-smartparens)

(require-package 'smartparens)
(require 'smartparens-config)

(setq sp-autoinsert-quote-if-followed-by-closing-pair nil)

(if dotemacs-smartparens/autoinsert
    (progn
      (setq sp-autoinsert-pair t)
      (electric-pair-mode -1))
  (setq sp-autoinsert-pair nil))

(sp-use-smartparens-bindings)
(smartparens-global-mode t)

(when dotemacs-smartparens/show-paren
  (setq sp-show-pair-delay 0)
  (setq sp-show-pair-from-inside t)
  (show-paren-mode -1)
  (show-smartparens-global-mode t))

;; fix conflict where smartparens clobbers yas' key bindings
(after 'yasnippet
  (defadvice yas-expand (before advice-for-yas-expand activate)
    (sp-remove-active-pair-overlay)))

(provide 'init-smartparens)
