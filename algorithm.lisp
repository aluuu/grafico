(in-package #:grafico)

(defun format-2d-hash (h &key (stream t))
  (let* ((rows (alexandria:hash-table-keys h))
         (columns (alexandria:hash-table-keys (gethash (first rows) h))))
    (format stream " ~{ ~a~}~%" columns)
    (loop for r in rows
       do (format stream "~a~{ ~a~}~%" r (alexandria:hash-table-values (gethash r h))))))


;; TODO: remove «most-positive-fixnum» magic

(defmethod floyd-warshall ((graph graph) &key (weight-fn #'(lambda (g n1 n2) (if (connected-p g n1 n2) 1 most-positive-fixnum))))
  (let ((W (make-hash-table :test 'equal)))
    ;; initialization
    (loop for i in (nodes graph)
       do (loop for j in (nodes graph)
             do (progn
                  (when (null (gethash i W))
                    (setf (gethash i W) (make-hash-table :test 'equal)))
                  (setf (gethash j (gethash i W))
                        (funcall weight-fn graph i j)))))
    ;; algorithm
    (loop for k in (nodes graph)
       do (loop for i in (nodes graph)
             do (loop for j in (nodes graph)
                   do (setf (gethash j (gethash i W))
                            (min (gethash j (gethash i W)) (+ (gethash k (gethash i W)) (gethash j (gethash k W))))))))
    ;; removing magic numbers
    (loop for i in (nodes graph)
       do (loop for j in (nodes graph)
             do (when (= (gethash j (gethash i W)) most-positive-fixnum)
                  (setf (gethash j (gethash i W)) 0))))
    W))
