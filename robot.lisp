;;Robot Structure
(in-package #:toyrobot)

(defstruct robot x y facing &optional table (fspeed 1) (rspeed 0.5))

;;Robot functions

(defun move-robot (r) (if (placed? r) (forward r) r))

(defun report-robot (r lookup)
  (if (placed? r) (with-slots (x y facing) r 
    (format t "~d,~d,~f,~a~%" (round x) (round y) facing (lookup facing)) r )))

(defun place-robot (r x y facing &optional (table (robot-table r)))
  (if (on-table? x y table)
      (make-robot :x x :y y :facing facing :table table)
      r))

(defun left-robot (r) (turn-robot r #'toleft))
(defun right-robot (r) (turn-robot r #'toright))

;;Helper functions

(defun turn-robot (r fn)
  (if (placed? r) (with-slots (x y facing rspeed) r
    (place-robot r x y (mod (funcall fn facing rspeed) 2))) r ))

(defun forward (r)
  (with-slots (x y facing fspeed) r
    (place-robot r (+ x (* fspeed (cos (* pi facing))))
            (+ y (* fspeed (sin (* pi facing))))
            facing)))

(defun on-table? (x y table)
    (with-slots (llx lly urx ury) table
      (and table (<= llx x)(<= lly y)(>= urx x)(>= ury y))))

(setf (symbol-function `toleft) (symbol-function `+))
(setf (symbol-function `toright) (symbol-function `-))

(defun placed? (r)
  (with-slots (x y facing) r
    (and x y facing)))

