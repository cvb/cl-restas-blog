;; Copyright 2010 Peter Goncharov

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or	
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(in-package :restas-blog)

(defclass post ()
  ((id :col-type serial :accessor id-of)
   (author :col-type integer :initarg :author :accessor author-of)
   (title :col-type (varchar 255) :initarg :title :accessor title-of)
   (content :initarg :content :accessor content-of))
  (:metaclass dao-class)
  (:keys title))

(defmethod get-path ((post post))
  (concatenate 'string *path-to-posts* (format nil "/~d/" (id-of post)) (title-of post)))

(defun make-path-to-post (id)
  (concatenate 'string *path-to-posts* (format nil "/~d/" id)))

(defun add-post (author title content)
  (let* ((p (with-connection *db*
	      (insert-dao (make-instance 'post :author author :title title))))
	 (path (ensure-directories-exist (make-path-to-post (id-of p))))
	 (fname (concatenate 'string path title)))
    (format t "~&~a~%" fname)
    (with-open-file (s fname
		       :if-does-not-exist :create
		       :if-exists :error
		       :direction :output)
      (princ content s))))

(defun get-post-by-title (title)
  (let ((p (get-dao 'post title)))
    (when p
      (with-open-file (s (get-path p)
			 :direction :input)
	(setf (content-of p) (alexandria:read-file-into-string s)))
      p)))

(defmethod remove-post-by-title (title)
  (with-connection *db*
    (let ((p (get-dao 'post title)))
     (when p
       (cl-fad:delete-directory-and-files (make-path-to-post (id-of p)) :if-does-not-exist :ignore)
       (delete-dao p)))))

(defun check-post-table-existence ()
  (with-connection *db*
    (table-exists-p (dao-table-name 'post))))

(defun create-post-table ()
  (with-connection *db*
    (query (dao-table-definition 'post))))

(defun init-post ()
  (when (not (check-post-table-existence))
    (create-post-table)))