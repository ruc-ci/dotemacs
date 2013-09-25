(require-package 'evil)
(require-package 'evil-leader)
(require-package 'evil-nerd-commenter)
(require-package 'surround)

(setq evil-magic 'very-magic)
(setq evil-want-C-u-scroll t)
(setq evil-want-C-w-in-emacs-state t)
(setq evil-search-module 'evil-search)

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-insert-state-cursor '("orange" bar))

(setq evilnc-hotkey-comment-operator "gc")

(require 'evil)
(require 'evil-leader)
(require 'evil-nerd-commenter)
(require 'surround)

(global-evil-leader-mode)
(evil-mode t)
(global-surround-mode 1)

(defun my-evil-cursor-insert-iterm () (send-string-to-terminal "\e]50;CursorShape=1\x7"))
(defun my-evil-cursor-normal-iterm () (send-string-to-terminal "\e]50;CursorShape=0\x7"))
(defun my-evil-cursor-insert-tmux-iterm () (send-string-to-terminal "\ePtmux;\e\e]50;CursorShape=1\x7\e\\"))
(defun my-evil-cursor-normal-tmux-iterm () (send-string-to-terminal "\ePtmux;\e\e]50;CursorShape=0\x7\e\\"))
(defun my-evil-terminal-cursor-change ()
  (remove-hook 'evil-insert-state-entry-hook 'my-evil-cursor-insert-iterm)
  (remove-hook 'evil-insert-state-exit-hook 'my-evil-cursor-normal-iterm)
  (remove-hook 'evil-insert-state-entry-hook 'my-evil-cursor-insert-tmux-iterm)
  (remove-hook 'evil-insert-state-exit-hook 'my-evil-cursor-normal-tmux-iterm)
  (unless (display-graphic-p)
    (when (string= (getenv "TERM_PROGRAM") "iTerm.app")
      (add-hook 'evil-insert-state-entry-hook 'my-evil-cursor-insert-iterm)
      (add-hook 'evil-insert-state-exit-hook 'my-evil-cursor-normal-iterm))
    (when (and (getenv "TMUX") (string= (getenv "TERM_PROGRAM") "iTerm.app"))
      (add-hook 'evil-insert-state-entry-hook 'my-evil-cursor-insert-tmux-iterm)
      (add-hook 'evil-insert-state-exit-hook 'my-evil-cursor-normal-tmux-iterm))))

(add-hook 'after-make-frame-functions (lambda (frame) (my-evil-terminal-cursor-change)))
(my-evil-terminal-cursor-change)

(defun my-evil-modeline-change (default-color)
  "changes the modeline color when the evil mode changes"
  (let ((color (cond ((minibufferp) default-color)
                     ((evil-insert-state-p) '("#000000" . "#ffffff"))
                     ((evil-visual-state-p) '("#010100" . "#ffffff"))
                     ((evil-emacs-state-p)  '("#5f0000" . "#ffffff"))
                     ((buffer-modified-p)   '("#001111" . "#ffffff"))
                     (t default-color))))
    (set-face-background 'mode-line (car color))
    (set-face-foreground 'mode-line (cdr color))))

(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
            (lambda () (my-evil-modeline-change default-color))))

(evil-define-text-object my-evil-next-match (count &optional beg end type)
  "Select next match."
  (evil-ex-search-previous 1)
  (evil-ex-search-next count)
  (list evil-ex-search-match-beg evil-ex-search-match-end))

(evil-define-text-object my-evil-previous-match (count &optional beg end type)
  "Select previous match."
  (evil-ex-search-next 1)
  (evil-ex-search-previous count)
  (list evil-ex-search-match-beg evil-ex-search-match-end))

(define-key evil-motion-state-map "gn" 'my-evil-next-match)
(define-key evil-motion-state-map "gN" 'my-evil-previous-match)

(provide 'init-evil)
