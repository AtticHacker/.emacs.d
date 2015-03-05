(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun ssh-add ()
  (interactive)
  (async-shell-command "ssh-add ~/.ssh/id_rsa"))

(defun get-battery-percentage ()
  (interactive)
  (concat (cdr (assoc '112 (funcall battery-status-function))) "%%"))

(defun tab-to-tab-stop-line-or-region (&optional left)
  (interactive)
  (if (region-active-p) (progn
  (if left
    (if (< (mark) (point))
    (indent-rigidly-left-to-tab-stop (mark) (point))
    (indent-rigidly-left-to-tab-stop (point) (mark)))
    (if (< (mark) (point))
    (indent-rigidly-right-to-tab-stop (mark) (point))
    (indent-rigidly-right-to-tab-stop (point) (mark))))
  (activate-mark)
  (error "Region tab"))
  (tab-to-tab-stop)))

(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))

(defun error-preview (buff)
  (interactive)
  (compile-goto-error)
  (switch-to-buffer-other-window buff))

(defun sh (buffer-name)
    "Start a terminal and rename buffer."
    (interactive "sbuffer name: ")
    (eshell)
    (rename-buffer (format "%s%s" "$" buffer-name) t))

(defun sht (buffer-name)
    "Start a terminal and rename buffer."
    (interactive "sbuffer name: ")
    (ansi-term "/bin/sh")
    (rename-buffer (format "%s%s" "$" buffer-name) t))

(defun my/grep (term)
    "Start a terminal and rename buffer."
    (interactive "sGrep value: ")
    (let ((term-list (split-string term)))
        (grep-find (format (concat
            "find . -type f "
            "! -name '*.log' "
            "! -name '*.dump' "
            "! -name '*#*' "
            "! -path '*/\.*' "
            "! -wholename '*/deps/*' "
            "! -wholename '*/tmp/*' "
            "! -wholename '*/elpa/*' "
            "! -wholename '*/backups/*' "
            "-exec grep -nH -e %s {} + "
            "| grep -v 'Binary file' "
        (mapconcat (lambda(X) (concat " | grep " X)) (cdr term-list) ""))
        term))))

(defun eshell-back-to-indentation ()
 (interactive)
 (eshell-bol)
 (while (and
    (char-after (point))
    (equal (string (char-after (point))) " "))
    (forward-char 1)))

(defun get-current-buffer-major-mode ()
    (interactive)
    (message "%s" major-mode))

(defun hoogle-search (query)
    "Search with hoogle commandline"
    (interactive "sHoogle query: ")
    (if (get-buffer "*Hoogle*") (kill-buffer "*Hoogle*"))
    ; get the version of hoogle so I don't have to manually adjust it for each update
    (shell-command (format "version=`hoogle --version | head -n 1 | awk '{print $2}' |
        cut -c 2- | rev | cut -c 2- | rev`;
        data=\"/databases\";
        two=$version$data;
        hoogle \"%s\" --data=$HOME/.lazyVault/sandboxes/hoogle/cabal/share/hoogle-$two" query))
    (switch-to-buffer "*Shell Command Output*")
    (rename-buffer "*Hoogle*")
    (haskell-mode)
    (linum-mode 0)
    (previous-buffer))

(defun ensure-buffer-name-begins-with-exl ()
    "change buffer name to end with slash"
    (let ((name (buffer-name)))
        (if (not (string-match "/$" name))
            (rename-buffer (concat "!" name) t))))

(defun erlang-get-error ()
    (interactive)
    (async-shell-command (format "~/.emacs.d/scripts/erlang/erlang-flymake %s" buffer-file-name) "[Erlang Errors]"))

(defun run-haskell-test ()
    (interactive)
    (my-up-to-script "*.cabal" "cabal build ; cabal test --log=/dev/stdout" "[Haskell Tests]"))

(defun run-make-input (input)
    "Run make with user input."
    (interactive "sMake: ")
    (run-make input "[Custom Make]"))

(defun run-make (arg name)
    (interactive)
    (if (get-buffer name) (kill-buffer name))
    (my-up-to-script "Makefile" (concat "make " arg) name))

(defun guard ()
    (interactive)
    (my-up-to-script "Guardfile" "bundle exec guard start --clear" "[Guard]"))

(defun run-mix (arg)
    (interactive)
    (my-up-to-script "mix.exs" (concat "mix " arg) "[Mix]"))

(defun underscores-to-camel-case (str)
    "Converts STR, which is a word using underscores, to camel case."
    (interactive "S")
    (apply 'concat (mapcar 'capitalize (split-string str "_"))))

; God functions

(defun god-mode-disable () (interactive)
    (god-mode-all-set -1)
    (god-local-mode -1)
    (key-chord-mode 1)
    (if window-system
        (set-cursor-color "green")
        (if (getenv "DISPLAY")
            (if (getenv "TMUX")
            (send-string-to-terminal "\033Ptmux;\033\033]12;Green\007\033\\")
            (send-string-to-terminal "\033]12;Green\007"))))
            (message nil))

(defun god-mode-enable () (interactive)
    (god-mode-all-set 1)
    (god-local-mode 1)
    (if window-system
        (set-cursor-color "white")
        (if (getenv "DISPLAY")
            (if (getenv "TMUX")
                (send-string-to-terminal "\033Ptmux;\033\033]12;White\007\033\\")
                (send-string-to-terminal "\033]12;White\007")))))

(defun god-mode-all-set (arg)
  "Set God mode in all buffers by argument."
  (interactive)
  (setq god-global-mode t)
  (mapc (lambda (buffer)
    (with-current-buffer buffer
        (god-mode-maybe-activate arg)))
    (buffer-list))
    (setq god-global-mode (= arg 1)))

(defun escape-key () (interactive)
    (deactivate-mark)
    (if (equal " *Minibuf-1*" (buffer-name))
        (keyboard-escape-quit)
        (unless (or multiple-cursors-mode macro-active (not god-local-mode) (not macro-active))
            (progn
                (call-interactively (key-binding (kbd "C-g")))
                (keyboard-escape-quit))))
    (god-mode-enable))

(defadvice keyboard-escape-quit (around my-keyboard-escape-quit activate)
    (let (orig-one-window-p)
        (fset 'orig-one-window-p (symbol-function 'one-window-p))
        (fset 'one-window-p (lambda (&optional nomini all-frames) t))
        (unwind-protect
            ad-do-it
            (fset 'one-window-p (symbol-function 'orig-one-window-p)))))

;; Vim's o key
(defun vim-o (&optional up)
    (interactive)
    (if up
        (progn
            (beginning-of-line)
            (open-line 1))
        (progn
        (end-of-line)
        (newline)))
    (if indent-of-doom-mode
        (indent-of-doom)
        (indent-for-tab-command))
    (god-mode-disable))

(defun command-repeater (list)
    (interactive)
    (setq char (string (read-event)))
    (setq repeater-command (cdr (assoc char list)))
    (if (or (not (boundp 'repeated-char)) (equal char repeated-char))
        (progn
            (if repeater-command
                (funcall repeater-command)
                (keyboard-quit))
            (setq repeated-char char)
            (command-repeater list))
        (progn
            (makunbound 'repeated-char)
            (call-interactively (key-binding (kbd char))))))

(defun god-g ()
    (interactive)
    (setq char (string (read-event)))
    (if (or (not (boundp 'repeated-char)) (equal char repeated-char))
        (progn
            (call-interactively (key-binding (kbd (format "M-%s" char))))
            (setq repeated-char char)
            (god-g))
        (progn
            (makunbound 'repeated-char)
            (call-interactively (key-binding (kbd char))))))

(defun helm-swoop-emms ()
    (interactive)
    (let ((current (current-buffer)))
    (split-window)
    (other-window 1)
    (emms-playlist-mode-go)
    (funcall (lambda ()
        (helm-swoop :$query "")
        (if (equal helm-exit-status 0) (emms-playlist-mode-play-smart))
        (delete-window)
        (switch-to-buffer current)
        (makunbound 'current)))))
(defun default-directory-full ()
    (if (equal (substring default-directory 0 1) "~")
        (format "/home/%s%s" (user-login-name) (substring default-directory 1))
        default-directory))

(defun home-directory ()
    (interactive)
    (format "/home/%s/" (user-login-name)))

(defun find-files-recursively-shell-command (x)
    (interactive)
    (format "find %s | grep -v '#' | grep -v '/\\.' | grep -v '/Downloads' |
        grep -v '/Dropbox' | grep -v '/Music' | grep -v '/Videos' | grep -v '/Pictures' |
        grep -v '/Mail' | grep -v 'ebin' | grep -v 'deps' | grep -v 'dist'" x))

(defun helm-swoop-find-files-recursively ()
    (interactive)
    (let ( (current (current-buffer))
           (current-dir default-directory))
        (switch-to-buffer "*helm-find-files-recursively*")
        (erase-buffer)
        (shell-command (find-files-recursively-shell-command (home-directory)) -1)
        (helm-swoop :$query "")
        (if (equal helm-exit-status 0)
            (setq final-location (buffer-substring
            (line-beginning-position) (line-end-position))))
        (switch-to-buffer current)
        (if (boundp 'final-location)
            (find-file final-location))
        (makunbound 'final-location)
        (makunbound 'current)))

(defun execute-c () (interactive)
    (if (buffer-file-name)
        (progn
            (shell-command (format "gcc -g -o %s %s"
            (file-name-sans-extension (buffer-name))
            (buffer-file-name)))
            (async-shell-command
                (format " ./%s" (file-name-sans-extension (buffer-name)))))))

(defun execute-rust () (interactive)
    (if (buffer-file-name)
        (let ((result (shell-command-to-string (format "rustc %s ; echo $?" (buffer-file-name))))
              (origin (buffer-name)))
          (if (equal (get-return-code result) "0")
              (async-shell-command (format " ./%s" (file-name-sans-extension (buffer-name))) "[Rust Compile]")
              (progn
                  (async-shell-command "" "[Rust Compile]")
                  (switch-to-buffer "[Rust Compile]")
                  (insert result)
                  (switch-to-buffer origin))))))

(defun test-rust () (interactive)
    (if (buffer-file-name)
        (let ((result (shell-command-to-string (format "rustc --test %s ; echo $?" (buffer-file-name))))
              (origin (buffer-name)))
          (if (equal (get-return-code result) "0")
              (async-shell-command (format " ./%s" (file-name-sans-extension (buffer-name))) "[Rust Compile]")
              (progn
                  (async-shell-command "" "[Rust Compile]")
                  (switch-to-buffer "[Rust Compile]")
                  (insert result)
                  (switch-to-buffer origin))))))

(defun get-return-code (s)
    (nth 1 (reverse (split-string s "\n"))))

(defun iex-compile ()
    (interactive)
    (let ((current (buffer-name)))
        (elixir-mode-iex)
        (kill-line 0)
        (insert (format "c(\"%s\")" current))
        (comint-send-input)))

(defun copy-line (arg)
    "Copy lines (as many as prefix argument) in the kill ring"
    (interactive "p")
    (kill-ring-save (line-beginning-position)
        (line-beginning-position (+ 1 arg))))

(defun copy-line-fun (up)
    (let ((current (current-column)))
        (if (region-active-p)
            (progn
                (copy-region-as-kill (region-beginning) (region-end))
                (goto-char (if up (region-beginning) (region-end)))
                (if up (open-line 1) (newline 1))
                (yank))
            (progn
                (copy-line 1)
                (beginning-of-line)
                (yank)
                (if up (previous-line))
                (move-to-column current)))))

(defun copy-line-up ()
    (interactive)
    (copy-line-fun t))

(defun copy-line-down ()
    (interactive)
    (copy-line-fun nil))

(defun my-comment ()
    (interactive)
    (if (region-active-p)
        (comment-or-uncomment-region (region-beginning) (region-end))
        (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(when (require 'winner)
  (defvar winner-boring-buffers-regexp
    "\*[hH]elm.*\\|\*xhg.*\\|\*xgit.*")
  (defun winner-set1 (conf)
    ;; For the format of `conf', see `winner-conf'.
    (let* ((buffers nil)
           (alive
            ;; Possibly update `winner-point-alist'
            (loop for buf in (mapcar 'cdr (cdr conf))
               for pos = (winner-get-point buf nil)
               if (and pos (not (memq buf buffers)))
               do (push buf buffers)
               collect pos)))
      (winner-set-conf (car conf))
      (let (xwins) ; to be deleted
        ;; Restore points
        (dolist (win (winner-sorted-window-list))
          (unless (and (pop alive)
                       (setf (window-point win)
                             (winner-get-point (window-buffer win) win))
                       (not (or (member (buffer-name (window-buffer win))
                                        winner-boring-buffers)
                                (string-match winner-boring-buffers-regexp
                                              (buffer-name (window-buffer win))))))
            (push win xwins)))          ; delete this window

        ;; Restore marks
        (letf (((current-buffer)))
          (loop for buf in buffers
             for entry = (cadr (assq buf winner-point-alist))
             do (progn (set-buffer buf)
                       (set-mark (car entry))
                       (setf (winner-active-region) (cdr entry)))))
        ;; Delete windows, whose buffers are dead or boring.
        ;; Return t if this is still a possible configuration.
        (or (null xwins)
            (progn
              (mapc 'delete-window (cdr xwins)) ; delete all but one
              (unless (one-window-p t)
                (delete-window (car xwins))
                t))))))

  (defalias 'winner-set 'winner-set1))

(defun is-tramp-mode ()
    (tramp-tramp-file-p (buffer-file-name (current-buffer))))

(defun flymake-create-temp-intemp (file-name prefix)
  "Return file name in temporary directory for checking FILE-NAME.
This is a replacement for `flymake-create-temp-inplace'. The
difference is that it gives a file name in
`temporary-file-directory' instead of the same directory as
FILE-NAME.

For the use of PREFIX see that function.

Note that not making the temporary file in another directory
\(like here) will not if the file you are checking depends on
relative paths to other files \(for the type of checks flymake
makes)."
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (let* ((name (concat
                (file-name-nondirectory
                 (file-name-sans-extension file-name))
                "_" prefix))
         (ext  (concat "." (file-name-extension file-name)))
         (temp-name (make-temp-file name nil ext))
         )
    (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
    temp-name))

(defun spawn-eshell ()
  (interactive)
  (if (> (/ (window-width) 2) (window-height))
      (progn
        (split-window-horizontally)
        (other-window 1)
        (sh "TERM")
        )
    (progn
      (split-window)
      (other-window 1)
      (sh "TERM"))
    ))

(defun eshell-broadcast(&optional yank-eshell-input)
  (interactive)
  (if eshell-mode
      (let ((buff (get-buffer-window))
            (col (current-column)))
        (eshell-back-to-indentation)
        (setq eshell-indentation-column (point))
        (move-end-of-line 1)
        (setq eshell-oel-column (point))
        (kill-ring-save eshell-indentation-column eshell-oel-column)
        (move-to-column col)
        (unless yank-eshell-input (eshell-send-input))
        (other-window 1)
        (while (not (eq (get-buffer-window) buff))
          (if eshell-mode
              (progn
                (end-of-buffer)
                (yank)
                (unless yank-eshell-input (eshell-send-input))))
          (other-window 1)
          ))))

(defun eshell-broadcast-diff()
  (interactive)
  (let ((buff-win (get-buffer-window))
        (buff (current-buffer)))
    (other-window 1)
    (while (not (eq (get-buffer-window) buff-win))
      (if eshell-mode
          (progn
            (highlight-changes-mode -1)
            (highlight-compare-buffers buff (current-buffer))))
      (sleep-for 0.1)
      (end-of-buffer)
      (other-window 1)
      )
    (highlight-changes-mode -1)
    ))

(defadvice inferior-erlang (before inferior-erlang activate)
    (setq-local deps (remove-if-not 'identity
        (mapcar (lambda(x)
            (unless (or (equal x ".") (equal x ".."))
                (concat "../deps/" x "/ebin")))
             (directory-files "../deps"))))
    (setq-local core '("../ebin"))

    (setq inferior-erlang-machine-options
        (-flatten (mapcar (lambda(x)
            (setq-local ll '())
            (add-to-list 'll x)
            (add-to-list 'll "-pa")
            (add-to-list 'll "include")
            (add-to-list 'll "-I")
            ll) (append core deps)))))

(defadvice erlang-compile (before erlang-compile activate)
    (setq-local deps (remove-if-not 'identity
        (mapcar (lambda(x)
            (unless (or (equal x ".") (equal x ".."))
                (concat "../deps/" x "/ebin")))
             (directory-files "../deps"))))
    (setq-local core '("../ebin"))

    (setq inferior-erlang-machine-options
        (-flatten (mapcar (lambda(x)
            (setq-local ll '())
            (add-to-list 'll x)
            (add-to-list 'll "-pa")
            (add-to-list 'll "include")
            (add-to-list 'll "-I")
            ll) (append core deps)))))
    ;; (setq inferior-erlang-machine-options '("-pa" "../ebin/" "-pa" "../deps/ranch/ebin/"))


(defun upward-find-file (filename &optional startdir)
  "Move up directories until we find a certain filename. If we
  manage to find it, return the containing directory. Else if we
  get to the toplevel directory and still can't find it, return
  nil. Start at startdir or . if startdir not given"
  (interactive)
  (let ((dirname (expand-file-name
          (if startdir startdir ".")))
    (found nil) ; found is set as a flag to leave loop if we find it
    (top nil))  ; top is set when we get
            ; to / so that we only check it once

    ; While we've neither been at the top last time nor have we found
    ; the file.
    (while (not (or found top))
      ; If we're at / set top flag.
      (if (string= (expand-file-name dirname) "/")
      (setq top t))

      ; Check for the file
      (if (file-exists-p (expand-file-name filename dirname))
      (setq found t)
    ; If not, move up a directory
    (setq dirname (expand-file-name ".." dirname))))
    ; return statement
    (if found (concat dirname "/") nil)))

(defun capitalize-previous-word ()
  (interactive)
  (let ((old-point (point)))
      (backward-word)
      (capitalize-word 1)
      (goto-char old-point)))

(defadvice kmacro-start-macro (before kmacro-start-macro activate)
    (setq macro-active t))

(defadvice kmacro-end-or-call-macro-repeat (after kmacro-end-or-call-macro-repeat activate)
  (setq macro-active nil))

(defadvice erc (before erc activate)
  (setq erc-prompt-for-password nil)
      (load "~/.erc.gpg")
      (setq erc-password ercpass))

(defadvice digit-argument (before digit-argument activate)
    (set-mark-command nil)
    (deactivate-mark))

(defadvice forward-list (before forward-list activate)
    (set-mark-command nil)
    (deactivate-mark))

(defadvice backward-list (before backward-list activate)
    (set-mark-command nil)
    (deactivate-mark))

(defadvice helm-register (before helm-register activate)
    (setq helm-register-active t))

(defadvice helm-register (after helm-register activate)
    (makunbound 'helm-register-active))

(defadvice helm-swoop (before helm-swoop activate)
    (set-mark-command nil)
    (deactivate-mark)
    (setq helm-swoop-active t))

(defadvice helm-swoop (after helm-swoop activate)
    (makunbound 'helm-swoop-active))

(defun swap-lines-at-points (point1 point2)
    (goto-line point1)
    (beginning-of-line)
    (kill-line)
    (goto-line point2)
    (beginning-of-line)
    (yank)
    (kill-line)
    (goto-line point1)
    (beginning-of-line)
    (yank)
    (pop-mark))

(defun transpose-lines-at-point ()
  (interactive)
  (beginning-of-line)
  (let ((current (what-line-int)))
      (pop-to-mark-command)
      (let ((next (what-line-int)))
      (swap-lines-at-points current next))))

(defun what-line-int (&optional p)
    "Get the current line number as an int"
    (interactive)
    (save-restriction
        (widen)
        (save-excursion
            (beginning-of-line)
            (if p
                (1+ (count-lines 1 p))
                (1+ (count-lines 1 (point)))))))

(setq reg-num 0)
(defun inc-register ()
  (interactive)
  (setq reg-num (+ 1 reg-num))
  (point-to-register reg-num)
  (message nil))

(defun screenshot-frame ()
  (interactive)
  (shell-command-to-string
   (concat "sleep 1; "
           "import -window 0x2a00003 "
           "-crop 958x523+0+0 +repage /tmp/frames/`date +%s`.png")))

(defun camelcase-region (start end)
  "Changes region from snake_case to camelCase"
  (interactive "r")
  (save-restriction (narrow-to-region start end)
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
  (save-restriction (narrow-to-region start end)
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

(defun window-setup ()
    (interactive)
    (delete-other-windows)
    (sticky-window-keep-window-visible-frame)
    (split-window-horizontally)
    (other-window 1)
    (split-window-vertically)
    (sticky-window-keep-window-visible-frame)
    (other-window 1)
    (set-window-height 8)
    (set-window-width 80)
    (select-window-3)
    (twit)
    (sticky-window-keep-window-visible))

(defun cm-fast-step-upward ()
  "Step 3 lines up, recenteres the screen."
  (interactive)
  (forward-line -3)
  (recenter))

(defun cm-fast-step-downward ()
  "Step 3 lines down, recenteres the screen."
  (interactive)
  (forward-line 3)
  (recenter))


;; (require 'company)

;; (defconst erlang-modules
;;   '(
;;     "gen_server"
;;     "lists"
;;     "proplists"
;;     "supervisor"
;;     ))

;; (defconst erlang-lists-functions
;;   '(
;;     "lists:append"
;;     "lists:concat"
;;     "lists:flatten"
;;     "lists:foldl"
;;     "lists:foldr"
;;     "lists:map"
;;     ))

;; (defun company-sample-backend (command &optional arg &rest ignored)
;;   (interactive (list 'interactive))
;;   (case command
;;     (interactive (company-begin-backend 'company-sample-backend))
;;     (prefix (and (eq major-mode 'erlang-mode)
;;                  (company-grab-symbol)))

;;     (candidates
;;     (if  (looking-back "lists")
;;             erlang-lists-functions
;;         (remove-if
;;             (lambda (c) (not (string-prefix-p arg c)))
;;                erlang-modules)
;;         ))
;;     ))

;; (add-to-list 'company-backends 'company-sample-backend)


(defun flowdock ()
  (interactive)
  (setq-default erc-ignore-list '("*Flowdock*" "Flowdock" "-Flowdock-"))
  (setq-default erc-hide-list '("JOIN" "PART" "QUIT"))
  (erc-ssl :server "irc.flowdock.com"
           :nick "KevinR"
           :port 6697
           :password (concat "kevin.vanrooijen@spilgames.com" " " (read-passwd "Flowdock Password: "))))

(defhydra buffer-move (god-local-mode-map "; m")
  "buffer-move"
  ("n" buf-move-down)
  ("p" buf-move-up)
  ("f" buf-move-right)
  ("b" buf-move-left)

  ("l" buf-move-down)
  ("o" buf-move-up)
  ("p" buf-move-right)
  ("k" buf-move-left))
(provide 'my-functions)
