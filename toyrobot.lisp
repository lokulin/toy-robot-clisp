;;#!/usr/bin/clisp
;; Robot and Table structs
(defstruct robot x y facing &optional table (fspeed 1) (rspeed 0.5))
(defstruct table llx lly urx ury)

(setf *commands* "MOVELEFTRIGHTREPORTPLACE")
(defparameter *dirs* (make-hash-table :size 4))
(setf (gethash 'EAST *dirs*) '0)
(setf (gethash 'NORTH *dirs*) '0.5)
(setf (gethash 'WEST *dirs*) '1)
(setf (gethash 'SOUTH *dirs*) '1.5)

;;Robot Methods
(defun move (robot &rest args) 
  (with-slots (x y facing table) robot
      (if (on (lookingat robot) table) 
        (lookingat robot)
        robot
        )))

(defun lookingat (robot)
  (with-slots (x y facing table fspeed) robot
    (_place robot (+ x (* fspeed (cos (* pi facing))))
           (+ y (* fspeed (sin (* pi facing))))
           facing)))

(defun turn (robot fn)
  (with-slots (x y facing rspeed) robot
    (_place robot x y (mod (funcall fn facing rspeed) 2))))

(defun left (robot &rest args)
    (turn robot #'+))

(defun right (robot &rest args)
    (turn robot #'-))

(defun report (robot &rest args)
  (with-slots (x y facing) robot
      (format t "~d,~d,~a~%" x y facing)
      robot))

(defun _place (robot x y facing &optional (table (robot-table robot)))
  (make-robot :x x :y y :facing facing :table table))

(defun on (robot table)
  (with-slots (x y) robot
  (with-slots (llx lly urx ury) table
  (and table (<= llx x)(<= lly y)(>= urx x)(>= ury y)))))


;; Input, validation main loop
(defun place (robot args)
  (let ((direction (gethash (intern (subseq args (+ (search "," args :from-end t) 1))) *dirs*)))
    (if (not (null direction ))
    (_place robot 1 1 direction))))
    
(defparameter *robot* ())
(defparameter *table* (make-table :llx 0 :lly 0 :urx 4 :ury 4))

(setf *robot* (_place *robot* 0 0 0 *table*))

(with-open-file (input "examples/example6.txt")
   (loop for line = (read-line input nil)
      while line do
        (let ((command (subseq line 0 (search " " line))))
          (let ((arguments (if (equal command line) () (subseq line (search " " line)))))
            (if (search command *commands*) (setf *robot* (funcall (intern command) *robot* arguments)))))))
