;; Hooks
(defun clean-hook ()
  (interactive)
  (key-chord-mode 0)
  (nlinum-mode 0))

(defun key-chord-force ()
  (key-chord-mode 1)
  (message nil))

(defadvice ansi-term (after advice-term-line-mode activate)
  (clean-hook))

(defun fix-tabs (x)
  (indent-of-doom-mode t)
  (setq-local tab-width x))

(defun default-language-settings ()
  (key-chord-mode 1)
  (rainbow-delimiters-mode)
  (if window-system (nlinum-mode))
  (if window-system (hl-line-mode 1))
  (highlight-symbol-mode 1)
  (electric-pair-mode 1)
  (auto-complete-mode))

(add-hook 'sauron-mode-hook 'no-split)
(sauron-start-hidden)

(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'c-initialization-hook 'c-keys-hook)
(add-hook 'dired-mode-hook 'ensure-buffer-name-begins-with-exl)
(add-hook 'magit-mode-hook 'clean-hook)
(add-hook 'shell-mode-hook
          (lambda()
            (god-local-mode)
            (key-chord-mode 1)))

(add-hook 'doc-view-mode-hook 'clean-hook)
(add-hook 'w3m-mode-hook 'clean-hook)
(add-hook 'message-mode-hook (lambda () (key-chord-force) (electric-pair-mode 0)))

(add-hook 'isearch-mode-hook (lambda()
    (key-chord-mode 1)))

(add-hook 'racket-repl-mode-hook (lambda ()
    (define-key ac-complete-mode-map (kbd "<return>")
      (lambda() (interactive) (ac-stop) (racket-repl-eval-or-newline-and-indent)))))

;; Doom Indent Config
(setq doom-use-tab-cycle t)
(setq doom-region-cycle nil)

(setq my-doom '(
    (all . (
        ((and (prev 'ends-on "[") (current 'starts-with "]")) (prev 'indent))
        ((and (prev 'ends-on "{") (current 'starts-with "}")) (prev 'indent))
        ((and (prev 'ends-on "(") (current 'starts-with ")")) (prev 'indent))

        ((current 'starts-with "]" "}" ")") (prev 'indent -1))
        ((prev 'ends-on "[" "{" "(")        (prev 'indent 1))
        ((prev 'ends-on ",")                (prev 'indent))
    ))
    (erlang-mode . (
        ((prev 'ends-on "->" "fun" "of" "begin") (prev 'indent 1))
        ((prev 'ends-on ";") (prev 'indent -1))
        ((and (prev 'ends-on "end") (current 'starts-with "end")) (prev 'indent -1))
        ((current 'ends-on "end") (prev 'indent -1))
    ))
    (haskell-mode . (
        ((prev 'indent-char-is ",") (prev 'indent))
        ((prev 'indent-char-is "[") (prev 'indent))
        ((prev 'ends-on "=" "= do" "=do") (prev 'indent 1))
    ))
    (elixir-mode . (
        ((and (prev 'ends-on ") ->") (current 'starts-with "end")) (prev 'indent))
        ((prev 'ends-on ") ->") (prev 'indent 1))
    ))
))

;; Load mode on certain file extensions
(setq auto-mode-alist (append '(
    ("\\.less\\'"    . css-mode)
    ("\\.scss\\'"    . css-mode)
    ("Gemfile$"      . ruby-mode)
    ("Rakefile$"     . ruby-mode)
    ("\\.gemspec$"   . ruby-mode)
    ("\\.rake$"      . ruby-mode)
    ("\\.rb$"        . ruby-mode)
    ("\\.ru$"        . ruby-mode)
    ("\\.app.src\\'" . erlang-mode)
    ("rebar.conf"    . erlang-mode)
    ("\\.elm\\'"     . haskell-mode)
    ("\\.js\\'"      . js2-mode)
    ("\\.dtl\\'"     . web-mode)
    ("\\.eex\\'"     . web-mode)
    ("\\.erb\\'"     . web-mode)
    ("\\.tpl\\'"     . web-mode)
    ) auto-mode-alist))

(provide 'attic-hooks)

