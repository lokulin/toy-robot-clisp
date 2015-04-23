Toy Robot
=========

Toy Robot is a work in progress, common lisp implementation of a toy robot simulator mostly conforming to the specifications in the [problem description](PROBLEM.md).

Installing
----------

The easiest way to get things running is using a system package manager + quicklisp.

On Debian/Ubuntu systems this should be as easy as:

Installing common lisp and quicklisp:
```
sudo apt-get install clisp cl-quicklisp
```

Then from within the clisp REPL:
```
(quicklisp-quickstart:install :path "~/.clisp/quicklisp/")
(ql:add-to-init-file)
```

Finally:
Clone this repo to somewhere on your systems. E.g.:
```
git clone git@github.com:lokulin/toy-robot-clisp.git ~/src/clisp/toy-robot/
```

Running
-------

```
./run.lisp examples/example1.tst
```
