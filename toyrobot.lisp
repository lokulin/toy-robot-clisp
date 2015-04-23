;;;; toyrobot.lisp

;;; Toy Robot simulation runner. Reads and validates commands and sends them to the robot.

(in-package #:toyrobot)

;; Table structs
(defstruct table llx lly urx ury)

(defun finddirection (direction)
  (case (intern direction :toyrobot)
    ('NORTH 0.0)
    ('EAST 0.5)
    ('SOUTH 1.0)
    ('WEST 1.5)
    (otherwise nil)))

(defun lookup (direction)
  (case direction
    (0.0 "NORTH")
    (0.5 "EAST")
    (1.0 "SOUTH")
    (1.5 "WEST")
    (otherwise nil)))

(defun sendcommand (r command arguments)
  (if (equal arguments nil)
    ;; No user supplied arguments
    (case (intern command :toyrobot)
      ('MOVE (move-robot r))
      ('LEFT (left-robot r))
      ('RIGHT (right-robot r))
      ('REPORT (report-robot r #'lookup) r)
      (otherwise r))
    ;; User supplied arguments
    (case (intern command :toyrobot)
      ('PLACE
        (setf (values x y direction) (values-list (cl-ppcre:split "," arguments :limit 3)))
        (setf x (parse-integer x :junk-allowed t))
        (setf y (parse-integer y :junk-allowed t))
        (setf direction (finddirection direction))
        (if (notany #'null (list x y direction))
          (place-robot r x y direction)
          r))
      (otherwise r))))

(defun test-file (file)
  (let ((robot (make-robot :table (make-table :llx 0 :lly 0 :urx 4 :ury 4))))
     (with-open-file (input file)
      (loop for line = (read-line input nil)
          while line do
            (setf (values command arguments) (values-list (cl-ppcre:split " " line :limit 2)))
            (setf robot (sendcommand robot command arguments)))))
              (values))

