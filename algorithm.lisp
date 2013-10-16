(in-package #:grafico)

(defun format-2d-hash (h &key (stream t))
  (let* ((rows (alexandria:hash-table-keys h))
         (columns (alexandria:hash-table-keys (gethash (first rows) h))))
    (format stream " ~{ ~a~}~%" columns)
    (loop for r in rows
       do (format stream "~a~{ ~a~}~%" r (alexandria:hash-table-values (gethash r h))))))

;; TODO: remove «most-positive-fixnum» magic

(defmethod floyd-warshall ((graph graph) &key (weight-fn #'(lambda (g n1 n2) (if (connected-p g n1 n2) 1 most-positive-fixnum))))
  (let* ((idx->nodes (make-hash-table :test 'equal))
         (nodes-count (length (nodes graph)))
         (weights (make-array `(,nodes-count ,nodes-count) :element-type 'fixnum))
         (result (make-hash-table :test 'equal)))
    (loop
       for node in (nodes graph)
       for idx from 0
       do (setf (gethash idx idx->nodes) node))
    (loop for i from 0 to (- nodes-count 1)
       do (loop for j from 0 to (- nodes-count 1)
             do (setf (aref  weights i j) (funcall weight-fn graph (gethash i idx->nodes) (gethash j idx->nodes)))))
    (loop for k from 0 to (- nodes-count 1)
       do (loop for i from 0 to (- nodes-count 1)
             do (loop for j from 0 to (- nodes-count 1)
                   do (setf (aref weights i j)
                            (min (aref weights i j) (+ (aref weights i k) (aref weights k j)))))))
    (loop for i from 0 to (- nodes-count 1)
       do (progn (when (null (gethash (gethash i idx->nodes) result))
                   (setf (gethash (gethash i idx->nodes) result) (make-hash-table :test 'equal)))
                 (loop for j from 0 to (- nodes-count 1)
                    do (setf (gethash (gethash j idx->nodes) (gethash (gethash i idx->nodes) result))
                             (if (= (aref weights i j) most-positive-fixnum) 0 (aref weights i j))))))
    result))
