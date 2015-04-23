#!/usr/bin/clisp -q -i ~/.clisprc.lisp
;;-norc -lp /usr/share/common-lisp/source/**/ -lp ./

(ql:quickload :toyrobot)
;;(load :asdf)
;;(asdf:load-system :toyrobot)
(toyrobot:test-file (first *ARGS*))

