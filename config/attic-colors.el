(defun set-foreground-background (face foreground &optional background)
  (set-face-foreground face foreground)
  (if background (set-face-background face background)))

(defun sfb(l)
  (mapcar (lambda(list) (set-foreground-background (nth 0 list)(nth 1 list)(nth 2 list) )) l))

(load-theme 'sanityinc-tomorrow-night t)

(set-face-attribute 'highlight-symbol-face nil :inherit 'default)

(set-face-attribute 'neo-file-link-face nil :inherit 'helm-ff-file)
(set-face-attribute 'neo-button-face nil :inherit 'helm-ff-directory)

(set-face-attribute 'linum nil :inherit 'default)
(set-face-background 'linum nil)

(set-face-attribute 'ac-candidate-face nil :inherit 'company-tooltip-common)
(set-face-attribute 'ac-completion-face nil :inherit 'company-preview-common)
(set-face-attribute 'ac-selection-face nil :inherit 'company-tooltip-common-selection)

(set-face-background 'fringe 'unspecified)
(require 'whitespace)
(sfb '(
    (git-gutter+-added          "green" unspecified)
    (git-gutter+-deleted        "red" unspecified)
    (git-gutter+-modified       "magenta" unspecified)
    (git-gutter+-unchanged  unspecified "#383838")
    (font-lock-string-face      "cadet blue" unspecified)
    (highlight-symbol-face      "#fff" "gray20" )
    (neo-file-link-face         unspecified unspecified unspecified)
    (neo-button-face            unspecified unspecified unspecified)
    (whitespace-empty            "gray16" "#1d1f21")
    (whitespace-hspace           "gray16" "#1d1f21")
    (whitespace-indentation      "gray16" "#1d1f21")
    (whitespace-line             "gray16" "#1d1f21")
    (whitespace-newline          "gray16" "#1d1f21")
    (whitespace-space            "gray16" "#1d1f21")
    (whitespace-space-after-tab  "gray16" "#1d1f21")
    (whitespace-space-before-tab "gray16" "#1d1f21")
    (whitespace-tab              "gray16" "#1d1f21")
    (whitespace-trailing         "gray16" "#1d1f21")
    (ac-completion-face           unspecified unspecified)
    ;; (hl-line                     unspecified "gray14")
    (fringe                      unspecified "gray14")))

(defun daytime ()
  (interactive)
  (load-theme 'sanityinc-tomorrow-day t)
  (set-face-background 'hl-line nil)
  (set-face-attribute 'highlight-symbol-face nil :inherit 'highlight))

(setq whitespace-style
      '(face tabs spaces trailing
             space-before-tab indentation
             space-after-tab space-mark tab-mark))

;; Modeline

(defun modeline-region-counter ()
  (if (region-active-p)
    (format "%sC|%sW|%sL "
            (- (region-end) (region-beginning))
            (count-words (region-beginning) (region-end))
            (count-lines (region-beginning) (region-end)))
    ""))

(defun attic-gnus-notify ()
  (if (equal (gnus-mst-notify-modeline-form) "")
    (:eval (butlast (cdr (gnus-mst-notify-modeline-form))))) )

(setq attic-mode-line-format
      '(" " (:eval (concat "[" (number-to-string (escreen-get-current-screen-number)) "]")) " "
        ;; (attic-gnus-notify) TODO fix this
        (:eval erc-modified-channels-object)
        "%*" "_"
        mode-line-remote " "
        (:eval (modeline-region-counter))
        "%3lL:%2cC "
        (:eval (format-time-string "%-I:%M%p")) " | "
        mode-line-buffer-identification " | "
        mode-name " |"
        (vc-mode vc-mode) " | "
        battery-mode-line-string))

(defun set-theme-white ()
  (interactive)
  (setq-default global-font-lock-mode nil)
  (setq-default mode-line-format nil)
  (setq mode-line-format nil)
  (set-face-background 'default "#fff")
  (set-face-foreground 'default "#000"))

(defun set-theme-black ()
  (interactive)
  (setq-default global-font-lock-mode nil)
  (setq-default mode-line-format nil)
  (setq mode-line-format nil)
  (set-face-background 'default "#000")
  (set-face-foreground 'default "#fff"))

(defun set-theme-hackergreen ()
  (interactive)
  (setq-default global-font-lock-mode nil)
  (setq-default mode-line-format nil)
  (setq mode-line-format nil)
  (global-font-lock-mode -1)
  (font-lock-mode -1)
  (set-face-background 'default "#000")
  (set-face-foreground 'default "#0DB804"))

(defun set-theme-default ()
  (interactive)
  (setq-default global-font-lock-mode t)
  (setq-default mode-line-format attic-mode-line-format)
  (setq mode-line-format attic-mode-line-format)
  (global-font-lock-mode t)
  (font-lock-mode t)
  (load-file "~/.emacs.d/config/attic-colors.el"))

(provide 'attic-colors)
