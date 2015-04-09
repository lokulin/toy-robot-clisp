;;#!/usr/bin/clisp
(ql:quickload :cl-ppcre)
(load "robot.lisp")
(in-package :cl-user)

(defpackage :com.lauchlin.toyrobot
  (:use :common-lisp)


(in-package :com.lauchlin.toyrobot)

;; Robot and Table structs
(defstruct table llx lly urx ury)

(setf *commands* "MOVELEFTRIGHTREPORTPLACE")
(defparameter *dirs* (make-hash-table :size 4))
(setf (gethash 'EAST *dirs*) '0)
(setf (gethash 'NORTH *dirs*) '0.5)
(setf (gethash 'WEST *dirs*) '1)
(setf (gethash 'SOUTH *dirs*) '1.5)

;; Input, validation main loop
(defun place (robot args)
  (let ((direction (gethash (intern (subseq args (+ (search "," args :from-end t) 1))) *dirs*)))
    (if (not (null direction ))
      (com.lauchlin.robot:place robot 1 1 direction))))

(defparameter *robot* ())
(defparameter *table* (make-table :llx 0 :lly 0 :urx 4 :ury 4))

(setf *robot* (com.lauchlin.robot:place *robot* 0 0 0 *table*))

#|(with-open-file (input "examples/example6.txt")
  (loop for line = (read-line input nil)
        while line do
        (let ((command (subseq line 0 (search " " line))))
          (let ((arguments (if (equal command line) () (subseq line (search " " line)))))
            (if (search command *commands*) (setf *robot* (funcall (intern command) *robot* arguments)))))))#|
