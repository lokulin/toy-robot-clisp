#!/usr/bin/clisp -i ~/.clisprc.lisp

(ql:quickload :toyrobot)
(toyrobot:test-file (first *ARGS*))

