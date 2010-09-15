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
  (id :col-type serial id-of)
  (author :col-type integer :initarg :author :accessor author-of)
  (title :col-type (varchar 255) :initarg :title :accessor title-of)
  (:metaclass dao-class))

(defun add-post (author title content))

(defun get-post ())

(defmethod remove-post ())

(defun check-post-table-existence ()
  (with-connection *db*
    (table-exists-p (dao-table-name 'post))))

(defun create-post-table ()
  (with-connection *db*
    (query (dao-table-definition 'post))))

(defun init-userauth ()
  (when (not (check-userauth-existence))
    (create-post-table)))