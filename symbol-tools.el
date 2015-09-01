;;; symbol-tools.el --- helper functions for handling symbols

;; Filename: symbol-tools.el
;; Description: helper functions for handling symbols
;; Author: Joe Bloggs <vapniks@yahoo.com>
;; Maintainer: Joe Bloggs <vapniks@yahoo.com>
;; Copyleft (Ↄ) 2015, Joe Bloggs, all rites reversed.
;; Created: 2015-09-01 20:22:36
;; Version: 0.1
;; Last-Updated: 2015-09-01 20:22:36
;;           By: Joe Bloggs
;; URL: https://github.com/vapniks/symbol-tools
;; Keywords: convenience
;; Compatibility: GNU Emacs 24.5.1
;; Package-Requires:  
;;
;; Features that might be required by this library:
;;
;; 
;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.
;; If not, see <http://www.gnu.org/licenses/>.

;;; Commentary: 
;;
;; Bitcoin donations gratefully accepted: 12k9zUo9Dgqk8Rary2cuzyvAQWD5EAuZ4q
;;
;; This file contains various helper functions for handling symbols. 
;; The code originally comes from chapter 4.7 of onlisp by Paul Graham:
;; http://www.bookshelf.jp/texi/onlisp/onlisp_5.html#SEC35
;; 
;;;;

;;; Functions:
;;
;;  - `mkstr' : Make a string from the list of `args'. Each arg can be a string or a symbol.
;;  - `symb' : Make a symbol from the list of `args'. Each arg can be a string or a symbol.
;;  - `reread' : Make a symbol from the list of `args'. Each arg can be a string or a symbol.
;;  - `explode' : Given symbol `sym', return a list of symbols for the individual chars making up `sym'.
;;  - `get-matching-symbols' : Return a list of all symbols in `obary' whose names match the regular expression `regex'.
;;  - `unintern-matching-symbols' : Remove all symbols whose name matches `regex' from the obarray `obary'.
;;


;;; Installation:
;;
;; Put symbol-tools.el in a directory in your load-path, e.g. ~/.emacs.d/
;; You can add a directory to your load-path with the following line in ~/.emacs
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;; where ~/elisp is the directory you want to add 
;; (you don't need to do this for ~/.emacs.d - it's added by default).
;;
;; Add the following to your ~/.emacs startup file.
;;
;; (require 'symbol-tools)

;;; Customize:
;;
;; To automatically insert descriptions of customizable variables defined in this buffer
;; place point at the beginning of the next line and do: M-x auto-document

;;
;; All of the above can customized by:
;;      M-x customize-group RET symbol-tools RET
;;

;;; Acknowledgements:
;;
;; Paul Graham (the code was taken from his book)
;;

;;; Code:

;; These are handy little functions I got from here: http://www.bookshelf.jp/texi/onlisp/onlisp_5.html#SEC28

;;;###autoload
(defun mkstr (&rest args)
  "Make a string from the list of `args'. Each arg can be a string or a symbol."
  (with-output-to-string (dolist (a args) (princ a))))

;;;###autoload
(defun symb (&rest args)
  "Make a symbol from the list of `args'. Each arg can be a string or a symbol."
  (intern (apply #'mkstr args)))

;;;###autoload
(defun reread (&rest args)
  "Make a symbol from the list of `args'. Each arg can be a string or a symbol.
          Returns a cons cell containing the symbol and the length of the symbol."
  (read-from-string (apply #'mkstr args)))

;;;###autoload
(defun explode (sym)
  "Given symbol `sym', return a list of symbols for the individual chars making up `sym'."
  (map 'list #'(lambda (c)
		 (intern (make-string 1 c)))
       (symbol-name sym)))

;;;###autoload
(defun get-matching-symbols (regex &optional obary)
  "Return a list of all symbols in `obary' whose names match the regular expression `regex'.
          If `obary' is missing then instead use `obarray', the standard obarry for ordinary symbols."
  (let (symlist)
    (mapatoms (function
	       (lambda (sym)
		 (if (string-match regex (symbol-name sym))
		     (setq symlist (cons sym symlist))))) obary)
    symlist))

;;;###autoload
(defun unintern-matching-symbols (regex &optional obary)
  "Remove all symbols whose name matches `regex' from the obarray `obary'.
    If `obary' is missing then instead use `obarray', the standard obarry for ordinary symbols.
    WARNING: use this function with care!"
  (dolist (sym (get-matching-symbols regex))
    (unintern sym obary)))


(provide 'symbol-tools)

;; (magit-push)
;; (yaoddmuse-post "EmacsWiki" "symbol-tools.el" (buffer-name) (buffer-string) "update")

;;; symbol-tools.el ends here

