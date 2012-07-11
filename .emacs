(setq-default c-basic-offset 4)
(global-set-key "\M-j" 'backward-word)
(global-set-key "\M-J" 'backward-kill-word)
(global-set-key "\M-k" 'forward-word)
(global-set-key "\M-K" 'kill-word)
(global-set-key "\C-c\C-r" 'rgrep)
(global-set-key "\C-cu" 'uncomment-region)
(global-set-key (kbd "C-<f12>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<f11>") 'shrink-window-horizontally)
(global-set-key (kbd "C-<f10>") 'enlarge-window)
(global-set-key (kbd "C-<f9>") 'shrink-window)
(global-set-key (kbd "\C-cc") 'comment-or-uncomment-region)
(global-set-key (kbd "\C-h") 'delete-backward-char)
(global-set-key (kbd "\C-cm") 'menu-bar-open)
(global-set-key (kbd "\C-xh") 'help)
(global-set-key (kbd "\C-ce")     (lambda()(interactive)(find-file "~/.emacs"))) ; open .emacs
(global-set-key (kbd "\C-cb")     (lambda()(interactive)(find-file "~/.bashrc"))) ; open .bashrc
(require 'paren) (show-paren-mode t)

;; http://www.emacswiki.org/emacs/KeyboardMacrosTricks
(defun save-macro (name)                  
  "save a macro. Take a name as argument
     and save the last defined macro under 
     this name at the end of your .emacs"
  (interactive "SName of the macro :")  ; ask for the name of the macro    
  (kmacro-name-last-macro name)         ; use this name for the macro    
  (find-file (user-init-file))                   ; open ~/.emacs or other user init file 
  (goto-char (point-max))               ; go to the end of the .emacs
  (newline)                             ; insert a newline
  (insert-kbd-macro name)               ; copy the macro 
  (newline)                             ; insert a newline
  (switch-to-buffer nil))               ; return to the initial buffer
;; end http://www.emacswiki.org/emacs/KeyboardMacrosTricks

;; clojure
;(load "~/.emacs.d/init-clojure.el")

;; slime
;; (eval-after-load "slime" 
;;   '(progn (slime-setup '(slime-repl))))

;; (add-to-list 'load-path "~/opt/slime")
;; (require 'slime)
;; (slime-setup) 

; groovy mode
; (load "~/.emacs.d/init-groovy.el")

; multimode and aspx mode
;(load "~/.emacs.d/multi-mode.el")
;(load "~/.emacs.d/aspx-mode.el")

; php mode
(add-to-list 'load-path "~/elisp")
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(defun clean-php-mode ()
(interactive)
(php-mode)
(setq c-basic-offset 4) ; 2 tabs i
(setq indent-tabs-mode nil)
(setq fill-column 78)
(c-set-offset 'case-label '+)
(c-set-offset 'arglist-close 'c-lineup-arglist-operators))
(c-set-offset 'arglist-intro '+)  
(c-set-offset 'arglist-cont-nonempty 'c-lineup-math)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

;(load "~/.emacs.d/nxhtml/autostart.el")
;(setq mumamo-background-colors nil)


; lispy things
;;; select db
(defun get-db-list () 
  (setq databases (shell-command-to-string "mysql -uroot -proot -e 'show databases;'"))
  (split-string databases)
)

(defun select-db ()
  (interactive)

  (split-window-horizontally)   ;; want two windows at startup 
  (other-window 1)              ;; move to other window
  (rename-buffer "select-db") ;; rename it
  
  (print databases)
)

(defun make-link (db-name) 
  (interactive)
  (message db-name)
)

(defun make-menu ()
  (setq db-list (get-db-list))

  (define-key-after global-map [menu-bar db-names]
    (cons "Available Databases" (make-sparse-keymap "db-names")))

  (while db-list
    (setq current-db (pop db-list))
    (define-key global-map [menu-bar db-names current-db]
      '(menu-item current-db (make-link current-db)
		  :help "suckatasha"))
    
;    (define-key global-map [menu-bar db-names separator-replace-tags]
;      '(menu-item "--"))
    )
  (define-key global-map [menu-bar db-names xbm]
      '(menu-item "xbm" xbm
		  :help "suckatasha"))
)
  
(make-menu)

; This pushes the backup files into an invisible directory named .~ in the directory of the corresponding file                                               
(setq backup-directory-alist '(("." . ".~")))
