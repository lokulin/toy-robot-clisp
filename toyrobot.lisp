#!/usr/bin/clisp
(defstruct robot x y facing)
(defstruct table llx lly urx ury)

(defun move (robot &optional (rspeed 1)) 
  (with-slots (x y facing) robot
    (place (+ x (* rspeed (round (cos (* pi facing)))))
           (+ y (* rspeed (round (sin (* pi facing)))))
           facing)))

(defun turn (robot fn rotation)
  (with-slots (x y facing) robot
    (place x y (mod (funcall fn facing rotation) 2))))

(defun left (robot &optional (rotation 0.5))
    (turn robot #'+ rotation))

(defun right (robot &optional (rotation 0.5))
    (turn robot #'- rotation))

(defun report (robot)
  (with-slots (x y facing) robot
      (format t "~d,~d,~a~%" x y facing)
      robot))

(defun place (x y facing)
  (make-robot :x x :y y :facing facing))

(defparameter *dirs* (make-hash-table :size 4))
(setf (gethash 'EAST *dirs*) '0)
(setf (gethash 'NORTH *dirs*) '0.5)
(setf (gethash 'WEST *dirs*) '1)
(setf (gethash 'SOUTH *dirs*) '1.5)

(defparameter *robot* ())
(defparameter *table* (make-table :llx 0 :lly 0 :urx 4 :ury 4))

(defun contains (table robot) 
  (and (<= 0 1)(<= 0 1)(>= 4 3)(>= 4 3)))

(setf *robot* (place 0 0 0))

(with-open-file (input "examples/example6.txt")
   (loop for line = (read-line input nil)
      while line do (setf *robot* (funcall (intern line) *robot*))))
