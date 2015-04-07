#!/usr/bin/clisp
(defstruct robot x y facing table &optional (fspeed 1) (rspeed 0.5))
(defstruct table llx lly urx ury)

(defun move (robot) 
  (with-slots (x y facing table) robot
      (if (on (lookingat robot) table) 
        (lookingat robot)
        robot
        )))

(defun lookingat (robot)
  (with-slots (x y facing table fspeed) robot
    (place (+ x (* fspeed (cos (* pi facing))))
           (+ y (* fspeed (sin (* pi facing))))
           facing table)))

(defun turn (robot fn)
  (with-slots (x y facing table rspeed) robot
    (place x y (mod (funcall fn facing rspeed) 2) table)))

(defun left (robot)
    (turn robot #'+))

(defun right (robot)
    (turn robot #'-))

(defun report (robot)
  (with-slots (x y facing) robot
      (format t "~d,~d,~a~%" x y facing)
      robot))

(defun place (x y facing table)
  (make-robot :x x :y y :facing facing :table table))

(defun on (robot table)
  (with-slots (x y) robot
  (with-slots (llx lly urx ury) table
  (and (<= llx x)(<= lly y)(>= urx x)(>= ury y)))))

(defparameter *dirs* (make-hash-table :size 4))
(setf (gethash 'EAST *dirs*) '0)
(setf (gethash 'NORTH *dirs*) '0.5)
(setf (gethash 'WEST *dirs*) '1)
(setf (gethash 'SOUTH *dirs*) '1.5)

(defparameter *robot* ())
(defparameter *table* (make-table :llx 0 :lly 0 :urx 4 :ury 4))

(setf *robot* (place 0 0 0 *table*))

(with-open-file (input "examples/example6.txt")
   (loop for line = (read-line input nil)
      while line do (setf *robot* (funcall (intern line) *robot*))))
