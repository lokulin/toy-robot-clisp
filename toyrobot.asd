;;;; toyrobot.asd

(asdf:defsystem #:toyrobot
  :description "A toy robot Simulator."
  :author "Lauchlin Wilkinson <lauchlin@lauchlin.com>"
  :license "GPL"
  :depends-on (#:cl-ppcre)
  :serial t
  :components ((:file "package")
               (:file "robot")
               (:file "toyrobot")))

