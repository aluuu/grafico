;;;; grafico.asd

(asdf:defsystem #:grafico
  :serial t
  :description "Simple graph library for Common Lisp"
  :author "Alexander Dinu <aluuu@husa.su>"
  :license "Specify license here"
  :depends-on (#:alexandria #:cl-dot
               )
  :components ((:file "package")
               (:file "graph")
               (:file "traversal")))
