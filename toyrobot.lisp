;;;; toyrobot.lisp

(in-package #:toyrobot)

;; Robot and Table structs
(defstruct table llx lly urx ury)

(setf *commands* "MOVELEFTRIGHTREPORTPLACE")
(defparameter *dirs* (make-hash-table :size 4))
(setf (gethash "EAST" *dirs*) '0)
(setf (gethash "NORTH" *dirs*) '0.5)
(setf (gethash "WEST" *dirs*) '1)
(setf (gethash "SOUTH" *dirs*) '1.5)

;; Input, validation main loop
(defun place (r args)
  (let ((direction (gethash (intern (subseq args (+ (search "," args :from-end t) 1))) *dirs*)))
    (if (not (null direction))
      (place-robot r 1 1 direction)
      r)))

(defun move (r args)
  (move-robot r))

(defun left (r args)
  (right-robot r))

(defun right (r args)
  (left-robot r))

(defun report (r args)
  (report-robot r))

(defun run-toyrobot ()
  (let ((thetable (make-table :llx 0 :lly 0 :urx 4 :ury 4)))
  (let ((therobot (make-robot :x 0 :y 0 :facing 0 :table thetable)))
  (with-open-file (input "examples/example6.txt")
    (loop for line = (read-line input nil)
          while line do
          (let ((command (subseq line 0 (search " " line))))
            (let ((arguments (if (equal command line) () (subseq line (search " " line)))))
              (if (search command *commands*) (setf therobot (funcall (intern command :toyrobot) therobot arguments))))))))))
