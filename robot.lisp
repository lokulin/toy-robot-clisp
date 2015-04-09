;;Robot Structure
(in-package :cl-user)

(defpackage :com.lauchlin.robot
  (:use :common-lisp)
  (:export #:place))

(in-package :com.lauchlin.robot)

(defstruct robot x y facing &optional table (fspeed 1) (rspeed 0.5))

;;Robot functions

(defun move (robot &rest args) 
  (with-slots (x y facing table) robot
    (if (on (lookingat robot) table) 
      (lookingat robot)
      robot
      )))

(defun report (robot &rest args)
  (with-slots (x y facing) robot
    (format t "~d,~d,~a~%" x y facing)
    robot))

(defun place (robot x y facing &optional (table (robot-table robot)))
  (make-robot :x x :y y :facing facing :table table))

(defun left (robot &rest args)
  (turn robot #'+))

(defun right (robot &rest args)
  (turn robot #'-))

;;Helper functions

(defun turn (robot fn)
  (with-slots (x y facing rspeed) robot
    (place robot x y (mod (funcall fn facing rspeed) 2))))

(defun on (robot table)
  (with-slots (x y) robot
    (with-slots (llx lly urx ury) table
      (and table (<= llx x)(<= lly y)(>= urx x)(>= ury y)))))

(defun lookingat (robot)
  (with-slots (x y facing table fspeed) robot
    (place robot (+ x (* fspeed (cos (* pi facing))))
            (+ y (* fspeed (sin (* pi facing))))
            facing)))

