;;; tehom-1.el --- Emacs lisp extensions for gnus' eforms

;; Copyright (C) 1999 by Tom Breton

;; Author: Tom Breton <Tehom@localhost>
;; Keywords: extensions

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;tehom-edit-form is a generalization of edit-form (Which is very
;;cool; thanks Lars)

;; This requires gnus-eform and gnus-util.  

;; Known Bugs:
;;
;; Help documentation is the gnus-eform's original, not this
;; package's.

;;; Code:

(require 'gnus-eform) 
(require 'gnus-util) 


(defvar documentation nil  
   "Buffer-local variable holding a forms' documentation." )

(defun tehom-edit-form 
  (form documentation-0 exit-func &optional mode-map setup-func)
  "Edit FORM in a new buffer.
Call EXIT-FUNC on exit.  Display DOCUMENTATION in the beginning
of the buffer."
  (let ((winconf (current-window-configuration)))

    (switch-to-buffer-other-window 
      (gnus-get-buffer-create gnus-edit-form-buffer))

    (gnus-edit-form-mode)
    (if mode-map
      (use-local-map mode-map))

    ;;These variables are always there.
    (setq gnus-prev-winconf winconf)
    (setq gnus-edit-form-done-function exit-func)

    ;;Doc string should always be available.
    (make-local-variable 'documentation)
    (setq documentation documentation-0)
    
    ;;Call other desired setup functionality 
    (if setup-func
      (funcall setup-func))

    (tehom-write-eform-contents form )))


(defun tehom-write-eform-contents (form)
  ""
  
  (erase-buffer)
  (insert documentation)
  (unless (bolp)
    (insert "\n"))
  (goto-char (point-min))
  (while (not (eobp))
    (insert ";;; ")
    (forward-line 1))
  (insert ";; Type `C-c C-c' after you've finished editing.\n")
  (insert "\n")

  (let ((p (point)))
    (pp form (current-buffer))
    (insert "\n")
    (goto-char p)))


(provide 'tehom-1)

;;; tehom-1.el ends here
