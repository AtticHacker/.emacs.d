(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.
With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file
       (concat "/sudo:root@localhost:"
               (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun tab-to-tab-stop-line-or-region (&optional left)
  (interactive)
  (let ((args) (function))
    (when (mark)
      (when (<  (mark) (point)) (setq args (list (mark)  (point))))
      (when (>= (mark) (point)) (setq args (list (point) (mark)))))
    (when (not left) (setq func 'indent-rigidly-right-to-tab-stop))
    (when left       (setq func 'indent-rigidly-left-to-tab-stop))
    (when (region-active-p)
      (apply func args)
      (activate-mark)
      (error "Region tab"))
    (unless (region-active-p)
      (tab-to-tab-stop))))

(defun tab-to-tab-stop-line-or-region-backward (&optional left)
  (interactive)
  (tab-to-tab-stop-line-or-region t))

(defun evil-paste-pop-or-kill-ring ()
  (interactive)
  (if (or (equal last-command 'evil-paste-after) (equal last-command 'evil-paste-pop))
      (evil-paste-pop 1)
    (helm-show-kill-ring)))

(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))

(defun cd-up-to-file (file)
  "Go up a directory until you find FILE or enter the root directory.
If file is found then return t else nil."
  (while (not (or (file-exists-p file) (equal default-directory "/")))
    (cd ".."))
  (file-exists-p file))

(defun kill-buffer-if-exists (buffer)
  "Attempt to kill BUFFER if it exists."
  (if (get-buffer buffer)
      (kill-buffer buffer)))

;;TODO: Create Make package
(defun reset-buffer (buffer)
  (kill-buffer-if-exists buffer)
  (generate-new-buffer buffer))

(defun run-make (arg name)
  (interactive)
  (reset-buffer "*Make Find Makefile*")
  (with-current-buffer "*Make Find Makefile*"
    (if (cd-up-to-file "Makefile")
        (progn
          (kill-buffer-if-exists name)
          (cond
           ((equal arg "start")
            (async-shell-command (concat "make " arg) name))
           (t
            (let ((comp-buffer (compile (concat "make " arg))))
              (with-current-buffer comp-buffer
                (rename-buffer name))))))
      (message "Could not find Makefile"))))

(defun attic/make-go ()
  (interactive)
  (run-make "go" "[Make go]"))

(defun attic/make-restart ()
  (interactive)
  (run-make "restart" "[Make Restart]"))

(defun attic/make-start ()
  (interactive)
  (run-make "start" "[Make Start]"))

(defun attic/make-stop ()
  (interactive)
  (run-make "stop" "[Make Stop]"))

(defun attic/make-test ()
  (interactive)
  (run-make "test" "[Make Test]"))

(defun attic/make-default ()
  (interactive)
  (run-make "" "[Make]"))

(defun attic/make-custom (input)
  "run make with user input."
  (interactive "sMake: ")
  (run-make input "[Custom Make]"))

(defun underscores-to-camel-case (str)
  "Converts STR, which is a word using underscores, to camel case."
  (interactive "S")
  (apply 'concat (mapcar 'capitalize (split-string str "_"))))

(defun capitalize-previous-word ()
  (interactive)
  (save-excursion
    (backward-word)
    (capitalize-word 1)))

(defun camelcase-region (start end)
  "Changes region from snake_case to camelCase"
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (goto-char (point-min))
    (while (re-search-forward "_\\(.\\)" nil t)
      (replace-match (upcase (match-string 1))))))

(defun camelcase-word-or-region ()
  "Changes word or region from snake_case to camelCase"
  (interactive)
  (let (pos1 pos2 bds)
    (if (and transient-mark-mode mark-active)
        (setq pos1 (region-beginning) pos2 (region-end))
      (progn
        (setq bds (bounds-of-thing-at-point 'symbol))
        (setq pos1 (car bds) pos2 (cdr bds))))
    (camelcase-region pos1 pos2)))

(defun camelcase-region+ (start end)
  "Changes region from snake_case to camelCase"
  (interactive "r")
  (save-restriction
    (narrow-to-region start end)
    (capitalize-region start end)
    (goto-char (point-min))
    (while (re-search-forward "_\\(.\\)" nil t)
      (replace-match (upcase (match-string 1))))))

(defun camelcase-word-or-region+ ()
  "Changes word or region from snake_case to camelCase"
  (interactive)
  (let (pos1 pos2 bds)
    (if (and transient-mark-mode mark-active)
        (setq pos1 (region-beginning) pos2 (region-end))
      (progn
        (setq bds (bounds-of-thing-at-point 'symbol))
        (setq pos1 (car bds) pos2 (cdr bds))))
    (camelcase-region+ pos1 pos2)))

(defun snakecase-word-or-region ()
  (interactive)
  (if mark-active (message "Don't have snakecase-region yet")
    (save-excursion
      (let ((bounds (bounds-of-thing-at-point 'word)))
        (replace-regexp "\\([A-Z]\\)" "_\\1" nil
                        (1+ (car bounds)) (cdr bounds))
        (downcase-region (car bounds) (cdr bounds))))))

(defun set-window-width (args)
  (shrink-window-horizontally (window-body-width))
  (enlarge-window-horizontally (- args (window-body-width))))

(defun set-window-height (args)
  (shrink-window (window-body-height))
  (enlarge-window (- args (window-body-height))))

(defun doc-center-window ()
  (interactive)
  (delete-other-windows)
  (split-window-right)
  (split-window-right)
  (select-window-by-number 1)
  (set-window-width 40)
  (switch-to-buffer "empty-buffer")
  (select-window-by-number 3)
  (set-window-width 40)
  (switch-to-buffer "empty-buffer")
  (select-window-by-number 2)
  (doc-view-fit-width-to-window))

(defun toggle-modeline ()
  (interactive)
  (if mode-line-format
      (setq mode-line-format nil)
    (setq mode-line-format attic-mode-line-format)))

(defun no-split ()
  (interactive)
  (setq-local split-width-threshold 2000)
  (setq-local split-height-threshold 2000))

(defun remove-newline-space ()
  (interactive)
  (cl-flet ((point-is-blank () (member (thing-at-point 'char t) '("\n" "\s"))))
    (unless (and (point-is-blank)
                 (equal (current-column) 0))
      (backward-char 1))
    (while (point-is-blank)
      (backward-char 1))
    (forward-char 1)
    (while (point-is-blank)
      (delete-char 1))
    (newline-and-indent)
    (unless (member major-mode '(scheme-mode))
      (newline-and-indent))))

(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags -f %s -e -R %s" tags-file-name (directory-file-name dir-name))))

(defun frame-name (frame)
  (frame-parameter frame 'name))

(defun frame-exists (name)
  (member name (mapcar 'frame-name (frame-list))))

(defun attic/setup-frames ()
  (interactive)
  (set-frame-name "Main")
  (select-frame-by-name "Main")
  (unless (-any 'elscreen-screen-live-p '(1 2 3 4 5))
    (elscreen-create-initial-5-screens))

  ;; Twitter Frame
  (unless (frame-exists "Twitter")
    (new-frame '((name . "Twitter"))))
  (select-frame-by-name "Twitter")
  (unless (get-buffer ":home")
    (twit))
  (elscreen-create-initial-5-screens)
  (switch-to-buffer ":home")

  ;; IRC Frame
  (unless (frame-exists "IRC")
    (new-frame '((name . "IRC"))))
  (select-frame-by-name "IRC")
  (elscreen-create-initial-5-screens)
  (let ((irc-buffer-exists (get-buffer "irc.freenode.net:6667")))
    (unless irc-buffer-exists
      (attic/erc))
    (elscreen-goto-2)
    (switch-to-buffer "irc.freenode.net:6667")
    (elscreen-goto-3)
    (switch-to-buffer "irc.freenode.net:6667")
    (elscreen-goto-4)
    (switch-to-buffer "irc.freenode.net:6667")
    (elscreen-goto-5)
    (switch-to-buffer "irc.freenode.net:6667")
    (elscreen-goto-1)
    (switch-to-buffer "irc.freenode.net:6667")))

(defun buffer-toggle ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) t)))

(defun insert! (value)
  (insert (format "%s" value)))

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(defun geiser-eval-next-sexp (print-to-buffer-p)
  "Eval the next sexp in the Geiser REPL.

With a prefix, print the result of the evaluation to the buffer."
  (interactive "P")
  (let* ((ret (geiser-eval-region (save-excursion (forward-sexp) (point))
                                  (point)
                                  nil
                                  t
                                  print-to-buffer-p))
         (str (geiser-eval--retort-result-str ret (when print-to-buffer-p ""))))
    (when (and print-to-buffer-p (not (string= "" str)))
      (push-mark)
      (insert str))))

(defmacro add-hook* (mode fn)
  `(add-hook ,mode (lambda () ,fn)))

(provide 'attic-functions)
