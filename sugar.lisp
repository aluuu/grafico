(in-package #:grafico)

(defmacro -> (item &rest rest)
  `(match ,item
     ((type hash-table) (reduce #'(lambda (key hash) (gethash hash key)) (list ,item ,@rest)))
     ((type simple-array) (aref ,item ,@rest))))
