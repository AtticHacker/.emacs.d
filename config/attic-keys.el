(define-key dired-mode-map           (kbd "<SPC>") 'attic-main/body)
(define-key doc-view-mode-map        (kbd "<SPC>") 'attic-main/body)
(define-key elfeed-search-mode-map   (kbd "<SPC>") 'attic-main/body)
(define-key elfeed-show-mode-map     (kbd "<SPC>") 'attic-main/body)
(define-key flyspell-mode-map        (kbd "<SPC>") 'attic-main/body)
(define-key grep-mode-map            (kbd "<SPC>") 'attic-main/body)
(define-key help-mode-map            (kbd "<SPC>") 'attic-main/body)
(define-key magit-revision-mode-map  (kbd "<SPC>") 'attic-main/body)
(define-key magit-status-mode-map    (kbd "<SPC>") 'attic-main/body)
(define-key messages-buffer-mode-map (kbd "<SPC>") 'attic-main/body)
(define-key mu4e-headers-mode-map    (kbd "<SPC>") 'attic-main/body)
(define-key mu4e-main-mode-map       (kbd "<SPC>") 'attic-main/body)
(define-key mu4e-view-mode-map       (kbd "<SPC>") 'attic-main/body)
(define-key package-menu-mode-map    (kbd "<SPC>") 'attic-main/body)
(define-key twittering-mode-map      (kbd "<SPC>") 'attic-main/body)

(defhydra attic-main (:color blue :columns 7)
  "Attic"
  ("<tab>" buffer-toggle "Buffer Toggle")
  ("`" elscreen-toggle "Elscreen Toggle")
  ("RET" nil)
  ("'" helm-org-capture-templates nil)
  ("." create-tags "Tag")
  ("0" elscreen-goto-0 nil)
  ("1" elscreen-goto-1 nil)
  ("2" elscreen-goto-2 nil)
  ("3" elscreen-goto-3 nil)
  ("4" elscreen-goto-4 nil)
  ("5" elscreen-goto-5 nil)
  ("6" elscreen-goto-6 nil)
  ("7" elscreen-goto-7 nil)
  ("8" elscreen-goto-8 nil)
  ("9" elscreen-goto-9 nil)
  (";" helm-M-x nil)
  ("<SPC>" evil-jump-backward "Jump backward" :color red)
  ("C-<SPC>" evil-jump-forward "Jump forward" :color red)
  ("M-d" helm-swoop nil)
  ("s" async-shell-command "ASync Shell")
  ("b" helm-buffers-list "Buffers")
  ("d" helm-swoop "Swoop")
  ("e" evil-geiser-eval-last-sexp "Eval")
  ("f" attic-file/body "File")
  ("w" attic-window/body "Window")
  ("n" attic-mc/body "Multi Cursor")
  ("g" magit-status "Magit")
  ("i" remove-newline-space nil)
  ("j" evil-normal-state "Lock")
  ("k" kill-buffer "Kill")
  ("m" attic-emms/body "EMMS")
  ("q" attic-make/body "Make")
  ("a" attic-projectile/body "Projectile")
  ("h" attic-help/body "Help")
  ("x" helm-M-x "M-x")
  ("r" rgrep "RGrep")
  ("t" transpose-mark nil)
  ("c" attic-macro/body "Macro"))

(defhydra attic-window (:color red :columns 4)
  "Attic Window"
  ("q" nil "Quit" :color blue)
  ("RET" nil :color blue)
  ("e" zoom-window-zoom "Zoom" :color blue)
  ("[" winner-undo "Winner Undo")
  ("]" winner-redo "Winner Redo")
  ("h" shrink-window-horizontally "Shrink Horizontally")
  ("l" enlarge-window-horizontally "Enlarge Horizontally")
  ("j" enlarge-window "Enlarge")
  ("k" shrink-window "Shrink")
  ("H" (lambda () (interactive) (shrink-window-horizontally 10)) "Shrink Horizontally")
  ("L" (lambda () (interactive) (enlarge-window-horizontally 10)) "Enlarge Horizontally")
  ("J" (lambda () (interactive) (enlarge-window 10)) "Enlarge")
  ("K" (lambda () (interactive) (shrink-window 10)) "Shrink")
  ("t" toggle-window-split "Toggle")
  ("w" buf-move-up "Up")
  ("s" buf-move-down "Down")
  ("a" buf-move-left "Left")
  ("d" buf-move-right "Right"))

(defhydra attic-mc (:color red :columns 4)
  "Attic MC"
  ("q" nil "Quit")
  ("e" attic-mc-edit/body "Edit" :color blue)
  ("l" attic-mc-like-this/body "Like this" :color blue)
  ("r" attic-mc-region/body "Region" :color blue)
  ("m" attic-mc-mmlte/body "Mmlte" :color blue)
  ("w" attic-mc-word/body "Word" :color blue)
  ("s" attic-mc-symbol/body "Symbol" :color blue)
  ("d" attic-mc-defun/body "Defun" :color blue)
  ("o" mc/mark-pop "mark-pop")
  ("@" mc/mark-all-dwim "mark-all-dwim")
  ("k" mc/keyboard-quit "keyboard-quit")
  ("f" mc/cycle-forward "cycle-forward")
  ("b" mc/cycle-backward "cycle-backward")
  ("va" mc/vertical-align "vertical-align")
  ("vs" mc/vertical-align-with-space "vertical-align-with-space")
  ("n" mc/mark-next-lines "mark-next-lines")
  ("p" mc/mark-previous-lines "mark-previous-lines")
  ("" mc/mark-sgml-tag-pair "mark-sgml-tag-pair")
  ("@" mc/mark-all-like-this "mark-all-like-this")
  ("n" mc/mark-next-like-this "mark-next-like-this")
  ("p" mc/mark-previous-like-this "mark-previous-like-this")
  ("N" mc/skip-to-next-like-this "skip-to-next-like-this")
  ("P" mc/skip-to-previous-like-this "skip-to-previous-like-this"))

(defhydra attic-mc-edit (:color red :columns 4)
  ("q" nil "Quit")
  ("<tab>" attic-mc/body "Back" :color blue)
  ("l" mc/edit-lines "edit-lines")
  ("b" mc/edit-beginnings-of-lines "edit-beginnings-of-lines")
  ("e" mc/edit-ends-of-lines "edit-ends-of-lines")
  ("i" mc/insert-numbers "insert-numbers"))

(defhydra attic-mc-like-this (:color red :columns 4)
  ("q" nil "Quit")
  ("<tab>" attic-mc/body "Back" :color blue)
  ("un" mc/unmark-next-like-this "unmark-next-like-this")
  ("d@" mc/mark-all-like-this-dwim "mark-all-like-this-dwim")
  ("up" mc/unmark-previous-like-this "unmark-previous-like-this")
  ("m" mc/mark-more-like-this-extended "mark-more-like-this-extended"))

(defhydra attic-mc-region (:color red :columns 4)
  ("q" nil "Quit")
  ("<tab>" attic-mc/body "Back" :color blue)
  ("s" mc/sort-regions "sort-regions")
  ("r" mc/reverse-regions "reverse-regions")
  ("@" mc/mark-all-in-region "mark-all-in-region")
  ("x" mc/mark-all-in-region-regexp "mark-all-in-region-regexp"))

(defhydra attic-mc-mmlte (:color red :columns 4)
  ("q" nil "Quit")
  ("<tab>" attic-mc/body "Back" :color blue)
  ("k" mc/mmlte--up "mmlte--up")
  ("h" mc/mmlte--left "mmlte--left")
  ("j" mc/mmlte--down "mmlte--down")
  ("l" mc/mmlte--right "mmlte--right"))

(defhydra attic-mc-word (:color red :columns 4)
  ("q" nil "Quit")
  ("<tab>" attic-mc/body "Back" :color blue)
  ("n" mc/mark-next-word-like-this "mark-next-word-like-this")
  ("@" mc/mark-all-words-like-this "mark-all-words-like-this")
  ("p" mc/mark-previous-word-like-this "mark-previous-word-like-this"))

(defhydra attic-mc-symbol (:color red :columns 4)
  ("q" nil "Quit")
  ("<tab>" attic-mc/body "Back" :color blue)
  ("n" mc/mark-next-symbol-like-this "mark-next-symbol-like-this")
  ("p" mc/mark-previous-symbol-like-this "mark-previous-symbol-like-this")
  ("@" mc/mark-all-symbols-like-this "mark-all-symbols-like-this"))

(defhydra attic-mc-defun (:color red :columns 4)
  ("t" mc/mark-all-like-this-in-defun "mark-all-like-this-in-defun")
  ("s" mc/mark-all-symbols-like-this-in-defun "mark-all-symbols-like-this-in-defun")
  ("w" mc/mark-all-words-like-this-in-defun "mark-all-words-like-this-in-defun"))

(defhydra attic-macro (:color blue :columns 4)
  "Attic Macro"
  ("s"    kmacro-start-macro "kmacro-start-macro")
  ("k"    kmacro-end-or-call-macro-repeat "kmacro-end-or-call-macro-repeat")
  ("r"    apply-macro-to-region-lines "apply-macro-to-region-lines")
  ("q"    kbd-macro-query "kbd-macro-query")
  ("C-n"  kmacro-cycle-ring-next "kmacro-cycle-ring-next")
  ("C-p"  kmacro-cycle-ring-previous "kmacro-cycle-ring-previous")
  ("C-v"  kmacro-view-macro-repeat "kmacro-view-macro-repeat")
  ("C-d"  kmacro-delete-ring-head "kmacro-delete-ring-head")
  ("C-t"  kmacro-swap-ring "kmacro-swap-ring")
  ("C-l"  kmacro-call-ring-2nd-repeat "kmacro-call-ring-2nd-repeat")
  ("C-f"  kmacro-set-format "kmacro-set-format")
  ("C-c"  kmacro-set-counter "kmacro-set-counter")
  ("C-i"  kmacro-insert-counter "kmacro-insert-counter")
  ("C-a"  kmacro-add-counter "kmacro-add-counter")
  ("C-e"  kmacro-edit-macro-repeat "kmacro-edit-macro-repeat")
  ("r"    kmacro-edit-macro "kmacro-edit-macro")
  ("e"    edit-kbd-macro "edit-kbd-macro")
  ("l"    kmacro-edit-lossage "kmacro-edit-lossage")
  (" "    kmacro-step-edit-macro "kmacro-step-edit-macro")
  ("b"    kmacro-bind-to-key "kmacro-bind-to-key")
  ("n"    kmacro-name-last-macro "kmacro-name-last-macro")
  ("x"    kmacro-to-register "kmacro-to-register"))

(defhydra attic-make (:color blue :columns 2)
  "[Make]"
  ("p" attic/make-stop    "Stop")
  ("r" attic/make-restart "Restart")
  ("s" attic/make-start   "Start")
  ("t" attic/make-test    "Test")
  ("o" attic/make-go      "Go")
  ("q" attic/make-default "Make")
  ("c" attic/make-custom  "Custom"))

(defhydra attic-file (:color blue :columns 2)
  "Attic File"
  ("f" helm-find-files "helm-find-files")
  ("b" helm-bookmarks "helm-bookmarks")
  ("j" helm-buffers-list "helm-buffers-list")
  ("h" previous-buffer "previous-buffer" :color red)
  ("l" next-buffer "next-buffer" :color red))

(defhydra attic-projectile (:color blue :columns 2)
  "Helm Projectile"
  ("a" helm-projectile "helm-projectile")
  ("b" helm-projectile-switch-to-buffer "helm-projectile-switch-to-buffer")
  ("c" helm-projectile-ack "helm-projectile-ack")
  ("d" helm-projectile-find-dir "helm-projectile-find-dir")
  ("e" helm-projectile-switch-to-eshell "helm-projectile-switch-to-eshell")
  ("s" helm-projectile-find-file "helm-projectile-find-file")
  ("g" helm-projectile-grep "helm-projectile-grep")
  ("i" helm-projectile-find-files-eshell-command-on-file-action "helm-projectile-find-files-eshell-command-on-file-action")
  ("k" helm-projectile-find-file-in-known-projects "helm-projectile-find-file-in-known-projects")
  ("o" helm-projectile-find-other-file "helm-projectile-find-other-file")
  ("r" helm-projectile-recentf "helm-projectile-recentf")
  ("f" helm-projectile-switch-project "helm-projectile-switch-project")
  ("t" helm-projectile-ff-etags-select-action "helm-projectile-ff-etags-select-action")
  ("w" helm-projectile-find-file-dwim "helm-projectile-find-file-dwim"))

(defhydra attic-help (:color blue :columns 2)
  "Helm Help"
  ("g" helm-geiser "helm-geiser"))

(provide 'attic-keys)
