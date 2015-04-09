;;Robot Structure
(in-package #:toyrobot)

(defstruct robot x y facing &optional table (fspeed 1) (rspeed 0.5))

;;Robot functions

(defun move-robot (r) 
  (if (on-table (in-front-of r)) 
    (in-front-of r)
    r
    ))

(defun report-robot (r)
  (with-slots (x y facing) r
    (format t "~d,~d,~a~%" x y facing)
    r))

(defun place-robot (r x y facing &optional (table (robot-table r)))
  (make-robot :x x :y y :facing facing :table table))

(defun left-robot (r)
  (turn-robot r #'+))

(defun right-robot (r)
  (turn-robot r #'-))

;;Helper functions

(defun turn-robot (r fn)
  (with-slots (x y facing rspeed) r
    (place-robot r x y (mod (funcall fn facing rspeed) 2))))

(defun on-table (r)
  (with-slots (x y table) r
    (with-slots (llx lly urx ury) table
      (and table (<= llx x)(<= lly y)(>= urx x)(>= ury y)))))

(defun in-front-of (r)
  (with-slots (x y facing fspeed) r
    (place-robot r (+ x (* fspeed (cos (* pi facing))))
            (+ y (* fspeed (sin (* pi facing))))
            facing)))

