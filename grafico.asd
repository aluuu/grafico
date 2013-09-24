;;;; grafico.asd

(asdf:defsystem #:grafico
  :serial t
  :description "Simple graph library for Common Lisp"
  :author "Alexander Dinu <aluuu@husa.su>"
  :license "Specify license here"
  :depends-on (#:alexandria #:s-dot)
  :components ((:file "package")
               (:file "graph")
               (:file "traversal")
               (:file "drawing")))
