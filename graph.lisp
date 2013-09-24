;;;; grafico.lisp

(in-package #:grafico)

;;; "grafico" goes here. Hacks and glory await!

(defclass deque (sequence standard-object)
  ((data :accessor items :initform '() :initarg :items)))

(defmethod append-right ((d deque) item)
  (setf (items d) (append (items d) `(,item))))

(defmethod append-left ((d deque) item)
  (setf (items d) (append `(,item) (items d))))

(defmethod pop-right ((d deque))
  (let ((result (lastcar (items d))))
    (setf (items d) (butlast (items d)))
    result))

(defmethod pop-left ((d deque))
  (let ((result (first (items d))))
    (setf (items d) (cdr (items d)))
    result))

(defmethod item-to-pop ((d deque))
  (first (items d)))

(defmethod sequence:length ((d deque))
  (length (items d)))

(defclass graph ()
  ((nodes :initform (make-hash-table :test 'equal) :accessor graph-nodes)
   (edges :initform (make-hash-table :test 'equal) :accessor graph-edges)
   (adjacency :initform (make-hash-table :test 'equal) :accessor graph-adj)))

(defmethod add-node ((graph graph) node &key (data (make-hash-table :test 'equal)))
  (setf (gethash node (graph-nodes graph)) data)
  node)

(defmethod set-node-data ((graph graph) node &key ))

(defmethod add-edge ((graph graph) source destination &key (data (make-hash-table :test 'equal)) (check-nodes t))
  (when check-nodes
    (when (not (member source (nodes graph)))
      (add-node graph source))
    (when (not (member destination (nodes graph)))
      (add-node graph destination)))
  (let ((edge (cons source destination)))
    (setf (gethash edge (graph-edges graph)) data
          (gethash source (graph-adj graph)) (cons destination (gethash source (graph-adj graph)))
          (gethash destination (graph-adj graph)) (cons source (gethash destination (graph-adj graph))))
    edge))

(defmethod nodes ((graph graph))
  (alexandria:hash-table-keys (graph-nodes graph)))

(defmethod edges ((graph graph))
  (alexandria:hash-table-keys (graph-edges graph)))

(defmethod neighbors ((graph graph) node)
  (reverse (gethash node (graph-adj graph))))

(defmethod remove-node ((graph graph) node)
  (let ((linked-edges (remove-if #'(lambda (edge) (not (or (equal node (cdr edge)) (equal node (car edge))) )) (edges graph))))
    (mapcar #'(lambda (edge)
                (progn
                  (remhash edge (graph-edges graph))
                  (setf (gethash (car edge) (graph-adj graph))
                        (remove (cdr edge) (gethash (car edge) (graph-adj graph)))
                        (gethash (cdr edge) (graph-adj graph))
                        (remove (car edge) (gethash (cdr edge) (graph-adj graph))))))
            linked-edges)
    (remhash node (graph-nodes graph))))

(defmethod remove-edge ((graph graph) (edge cons))
  (remhash edge (graph-edges graph))
  (setf (gethash (car edge) (graph-adj graph))
        (remove (cdr edge) (gethash (car edge) (graph-adj graph)))
        (gethash (cdr edge) (graph-adj graph))
        (remove (car edge) (gethash (cdr edge) (graph-adj graph)))))

(defclass digraph (graph) ())

(defmethod add-edge ((graph digraph) source destination &key (data (make-hash-table :test 'equal)) (check-nodes t))
  (when check-nodes
    (when (not (member source (nodes graph)))
      (add-node graph source))
    (when (not (member destination (nodes graph)))
      (add-node graph destination)))
  (let ((edge (cons source destination)))
    (setf (gethash edge (graph-edges graph)) data
          (gethash source (graph-adj graph)) (cons destination (gethash source (graph-adj graph))))
    edge))

(defmethod remove-edge ((graph digraph) (edge cons))
  (remhash edge (graph-edges graph))
  (setf (gethash (car edge) (graph-adj graph))
        (remove (cdr edge) (gethash (car edge) (graph-adj graph)))))

(defmethod edges->graph ((edges list) &key (graph-class 'graph))
  (let ((g (make-instance graph-class)))
    (mapcar #'(lambda (edge) (add-edge g (car edge) (cdr edge))) edges)
    g))

(defmethod connected-p ((graph graph) node1 node2)
  (not (null (member node2 (gethash node1 (graph-adj graph))))))
