(define-prefix-command 'attic-make-map)

(defun attic-key(key function)
  (define-key attic-mode-map (kbd key) function))

(global-set-key (kbd "C-M-]") 'attic-mode)
(mapcar (lambda(a) (attic-key (nth 0 a) (nth 1 a))) '(

("C-c C-o" switch-to-minibuffer)
("C-;" attic-semi-colon/body)
("C-z" helm-buffers-list)
("C-j" iy-go-to-char)
("M-j" iy-go-to-char-backward)
("C-q" backward-delete-char)
("M-q" backward-kill-word)
("C-M-q" backward-kill-sexp)
("C-x C-1" delete-other-windows)
("C-x C-2" split-window-below)
("C-x C-3" split-window-right)
("C-x C-8" fill-paragraph)
("C-x C-b" helm-buffers-list)
("C-c C-p" copy-line-up)
("C-c C-n" copy-line-down)
;; ;; Meta keys
("M-+" align-regexp)
("M-N" mc/mark-next-like-this)
("M-P" mc/mark-previous-like-this)
;("<return>" newline mc/keymap)
("M-C" capitalize-previous-word)
("M-i" tab-to-tab-stop-line-or-region)
("M-I" (lambda() (interactive) (tab-to-tab-stop-line-or-region t)))
("M-0" attic-sauron-toggle)
("M-9" attic-neotree-toggle)
("M-y" (lambda() (interactive)
         (if (or (equal last-command 'yank) (equal last-command 'yank-pop))
             (yank-pop)
           (helm-show-kill-ring))))))

(define-key attic-mode-map
  (kbd "C-;")
  (defhydra attic-semi-colon (:color blue)
    "Attic"
    ("'" helm-org-capture-templates nil)
    ("C-'" helm-org-capture-templates nil)
    ("." create-tags nil)
    ("C-." create-tags nil)
    ("0" xsescreen-goto-screen-0 nil)
    ("C-0" xsescreen-goto-screen-0 nil)
    ("1" escreen-goto-screen-1 nil)
    ("C-1" escreen-goto-screen-1 nil)
    ("2" escreen-goto-screen-2 nil)
    ("C-2" escreen-goto-screen-2 nil)
    ("3" escreen-goto-screen-3 nil)
    ("C-3" escreen-goto-screen-3 nil)
    ("4" escreen-goto-screen-4 nil)
    ("C-4" escreen-goto-screen-4 nil)
    ("5" escreen-goto-screen-5 nil)
    ("C-5" escreen-goto-screen-5 nil)
    ("6" escreen-goto-screen-6 nil)
    ("C-6" escreen-goto-screen-6 nil)
    ("7" escreen-goto-screen-7 nil)
    ("C-7" escreen-goto-screen-7 nil)
    ("8" escreen-goto-screen-8 nil)
    ("C-8" escreen-goto-screen-8 nil)
    ("9" escreen-goto-screen-9 nil)
    ("C-9" escreen-goto-screen-9 nil)
    (";" escreen-goto-last-screen nil)
    ("C-;" escreen-goto-last-screen nil)
    ("<SPC>" pop-to-mark-command nil)
    ("C-<SPC>" pop-to-mark-command nil)
    ("M-d" helm-swoop nil)
    ("C-M-d" helm-swoop nil)
    ("[" winner-undo nil)
    ("C-[" winner-undo nil)
    ("]" winner-redo nil)
    ("C-]" winner-redo nil)
    ("a" async-shell-command "ASync Shell")
    ("C-a" async-shell-command nil)
    ("b" helm-bookmarks "Bookmarks")
    ("C-b" helm-bookmarks nil)
    ("d" (lambda() (interactive) (helm-swoop :$query "")) "Swoop")
    ("C-d" (lambda() (interactive) (helm-swoop :$query "")) nil)
    ("e" eww "Eww")
    ("C-e" eww nil)
    ("f" helm-ls-git-ls "Git")
    ("C-f" helm-ls-git-ls nil)
    ("g" magit-status "Magit")
    ("i" remove-newline-space nil)
    ("C-i" remove-newline-space nil)
    ("j" attic-lock "Lock")
    ("C-j" attic-lock nil)
    ("k" kill-buffer "Kill")
    ("C-k" kill-buffer nil)
    ("n" sauron-select-last-event nil)
    ("C-n" sauron-select-last-event nil)
    ("q" attic-make/body "Make")
    ("C-q" attic-make/body nil)
    ("s" shell-command "Shell")
    ("C-s" shell-command nil)
    ("x" helm-M-x "M-x")
    ("C-x" helm-M-x nil)
    ("r" rgrep "RGrep")
    ("C-r" rgrep nil)))

(defhydra attic-make (:color blue)
  "toggle"
  ("p" (lambda() (interactive) (run-make "stop"    "[Make Stop]")) "Stop")
  ("r" (lambda() (interactive) (run-make "restart" "[Make Restart]")) "Restart")
  ("s" (lambda() (interactive) (run-make "start"   "[Make Start]")) "Start")
  ("t" (lambda() (interactive) (run-make "test"    "[Make Test]")) "Test")
  ("o" (lambda() (interactive) (run-make "go"      "[Make Go]")) "Go")
  ("q" (lambda() (interactive) (run-make ""        "[Make]")) "Make")
  ("c" run-make-input "Custom"))

(if window-system
    (progn
      (define-key attic-mode-map (kbd "C-S-V") 'x-clipboard-yank)
      (define-key attic-mode-map (kbd "C-S-C") 'clipboard-kill-ring-save)))

;; Make keys
(define-key isearch-mode-map (kbd "<escape>") 'isearch-abort)
(define-key isearch-mode-map (kbd "M-g") 'isearch-abort)
(define-key isearch-mode-map (kbd "TAB") 'isearch-exit)

;; Other Keys
(global-set-key [f3] 'describe-key)
(global-set-key [f4] 'send-to-pastie)
(global-set-key [f6] 'describe-mode)
(global-set-key [f7] 'get-current-buffer-major-mode)
(global-set-key [f9] 'toggle-menu-bar-mode-from-frame)
(global-set-key [f11] 'screenshot-frame)

;; C Keys
(defun c-keys-hook ()
(define-key c-mode-base-map (kbd "C-/") 'attic/comment))

;; Package Menu mode
(define-key package-menu-mode-map (kbd ";") 'attic-semi-colon/body)

(require 'doc-view)
(define-key doc-view-mode-map (kbd "j") 'doc-view-next-line-or-next-page)
(define-key doc-view-mode-map (kbd "k") 'doc-view-previous-line-or-previous-page)

(define-key doc-view-mode-map (kbd ";") 'attic-semi-colon/body)
(define-key doc-view-mode-map (kbd "z") 'helm-buffers-list)

(define-key help-mode-map (kbd ";") 'attic-semi-colon/body)
(define-key help-mode-map (kbd "z") 'helm-buffers-list)

(define-key messages-buffer-mode-map (kbd ";") 'attic-semi-colon/body)
(define-key messages-buffer-mode-map (kbd "z") 'helm-buffers-list)

(defun attic-minibuffer-setup-hook ()
  (attic-mode 0))

;; Other unset keys
(global-unset-key "\C-x\C-z")
(global-unset-key "\C-z")
(provide 'attic-keys)
