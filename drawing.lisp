(in-package #:grafico)

(defvar *dot-binary-location* "/usr/bin/dot")

(defun s-dotify (l)
  (map 'list (lambda (el)
               (if (listp el) (s-dotify el)
                   (if (symbolp el) (intern (symbol-name el) :S-DOT)
                       el))) l))

(defmethod graph->s-dot ((graph graph))
  (append `(graph ((rankdir "LR")))
          (map 'list (lambda (node) (list 'node `((id ,(format nil "~a" node)) (label ,(format nil "~a" node))))) (nodes graph))
          (map 'list (lambda (edge) (list 'edge `((from ,(format nil "~a" (car edge)))
                                             (to ,(format nil "~a" (cdr edge)))))) (edges graph))))

(defmethod render-graph ((graph graph) file-name format)
  (let ((s-graph (s-dotify (graph->s-dot graph)))
        (dot-file-name
         (make-pathname :directory (pathname-directory file-name)
                        :name (pathname-name file-name)
                        :type "dot")))
    (with-open-file (stream dot-file-name :direction :output :if-exists :supersede :if-does-not-exist :create)
      (s-dot->dot stream s-graph :check-syntax t))
    #+sbcl
    (sb-ext:run-program *dot-binary-location*
                        (list (format nil "~a" dot-file-name) (format nil "-T~(~a~)" format) (format nil "-o~A" file-name))
                        :output *standard-output*)))
