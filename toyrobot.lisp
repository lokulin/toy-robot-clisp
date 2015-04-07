#!/usr/bin/clisp
(defstruct robot location facing table)
(defstruct table llc urc)
(defstruct point x y)

(defun move (robot &optional (rspeed 1)) 
  (with-slots (location facing table) robot
      (if (on (lookingat location facing rspeed) table) 
        (place (lookingat location facing rspeed) facing table)
        robot
        )))

(defun lookingat (location facing rspeed)
  (with-slots (x y) location
    (make-point :x (+ x (* rspeed (round (cos (* pi facing)))))
                :y (+ y (* rspeed (round (sin (* pi facing))))))))

(defun turn (robot fn rotation)
  (with-slots (location facing table) robot
    (place location (mod (funcall fn facing rotation) 2) table)))

(defun left (robot &optional (rotation 0.5))
    (turn robot #'+ rotation))

(defun right (robot &optional (rotation 0.5))
    (turn robot #'- rotation))

(defun report (robot)
  (with-slots (location facing) robot
    (with-slots (x y) location
      (format t "~d,~d,~a~%" x y facing)
      robot)))

(defun place (location facing table)
  (make-robot :location location :facing facing :table table))

(defparameter *dirs* (make-hash-table :size 4))
(setf (gethash 'EAST *dirs*) '0)
(setf (gethash 'NORTH *dirs*) '0.5)
(setf (gethash 'WEST *dirs*) '1)
(setf (gethash 'SOUTH *dirs*) '1.5)

(defparameter *robot* ())
(defparameter *table* (make-table :llc (make-point :x 0 :y 0) :urc (make-point :x 4 :y 4)))

(defun on (point table)
  (with-slots (x y) point
  (with-slots (llc urc) table
  (with-slots ((llx x) (lly y)) llc
  (with-slots ((urx x) (ury y)) urc 
  (and (<= llx x)(<= lly y)(>= urx x)(>= ury y)))))))

(setf *robot* (place (make-point :x 0 :y 0) 0 *table*))

(with-open-file (input "examples/example6.txt")
   (loop for line = (read-line input nil)
      while line do (setf *robot* (funcall (intern line) *robot*))))
