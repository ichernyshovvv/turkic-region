;;; turkic-region.el --- Obfuscate buffer content -*- lexical-binding: t; -*-

;; Copyright (C) 2025  Ilya Chernyshov

;; Author: Ilya Chernyshov <ichernyshovvv@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "29.1"))
;; Keywords: tools, docs
;; URL: https://github.com/ichernyshovvv/turkic-region

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Obfuscate buffer content

;;; Code:

(defvar-local --original-content nil)

;;;###autoload
(defun turkic-region ()
  (interactive)
  (if --original-content
      (user-error "Buffer already obfuscated")
    (let ((inhibit-read-only t))
      (save-excursion
        (setq --original-content (buffer-string))
        (goto-char (point-min))
        (while (re-search-forward "[[:alpha:][:digit:]]+" nil t)
          (put-text-property (match-beginning 0) (point) 'display
                             (--random-string (- (point) (match-beginning 0)))))))))

(defun --random-string (len)
  (let (res)
    (dotimes (_ len (string-join res))
      (push (char-to-string (+ 97 (random 25))) res))))

;;;###autoload
(defun turkic-region-undo ()
  (interactive)
  (if --original-content
      (save-window-excursion
        (let ((beg (point)) (inhibit-read-only t))
          (erase-buffer)
          (insert --original-content)
          (goto-char beg)
          (setq --original-content nil)))
    (user-error "Nothing to undo")))

(provide 'turkic-region)

;; Local Variables:
;;   read-symbol-shorthands: (("-" . "turkic-region-"))
;; End:

;;; turkic-region.el ends here
