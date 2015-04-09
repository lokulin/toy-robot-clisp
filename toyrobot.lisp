;;;; toyrobot.lisp

;;; Toy Robot simulation runner. Reads and validates commands and sends them to the robot.

(in-package #:toyrobot)

;; Table structs
(defstruct table llx lly urx ury)

;; Input validation stuff
(defun validcommand? (command) 
    (search command "MOVELEFTRIGHTREPORTPLACE"))

(defun finddirection (direction)
  (case (intern direction :toyrobot)
    ('EAST 0)
    ('NORTH 0.5)
    ('WEST 1)
    ('SOUTH 1.5)
    (otherwise nil)))

(defun lookup (direction)
  (case direction 
    (0.0 "EAST")
    (0.5 "NORTH")
    (1.0 "WEST")
    (1.5 "SOUTH")
    (otherwise nil)))

;; place has arguments so split them out and send them
(defun place (r args)
  (let ((direction (finddirection (subseq args (+ (search "," args :from-end t) 1)))))
    (if (not (null direction))
      (place-robot r 1 1 direction)
      r)))

;; other commands don't have any arguments
(defun move (r args)
  (move-robot r))

(defun left (r args)
  (left-robot r))

(defun right (r args)
  (right-robot r))

(defun report (r args)
  (report-robot r #'lookup)
  r)

(defun run-toyrobot (file)
  (let ((thetable (make-table :llx 0 :lly 0 :urx 4 :ury 4)))
    (let ((therobot (make-robot :table thetable)))
    (with-open-file (input file)
      (loop for line = (read-line input nil)
          while line do
          (let ((command (subseq line 0 (search " " line))))
            (let ((arguments (if (equal command line) () (subseq line (search " " line)))))
              (if (validcommand? command) (setf therobot (funcall (intern command :toyrobot) therobot arguments))))))))))
