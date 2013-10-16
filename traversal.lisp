(in-package #:grafico)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deque

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Breadth-first search

(defmethod bfs ((graph graph) start &key (goal nil))
  (let ((queue (make-instance 'deque :items `(,start)))
        (visited '()))
    (loop while (> (length queue) 0)
       do (let ((v (pop-left queue)))
            (when (not (member v visited))
                (setf visited (cons v visited)))
            (if (not (equal goal v))
                (loop for e in (neighbors graph v)
                   do (when (not (member e visited))
                          (progn
                            (setf visited (cons e visited))
                            (append-right queue e)))))))
    (reverse visited)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Depth-first search
;;   supports :depth keyword argument, that turns DFS to DLS

(defmethod dfs ((graph graph) start &key (depth nil) (goal nil) (visited nil))
  (let ((visited (cons start visited)))
    (when (or (null depth) (> depth 1))
        (if (not (equal goal start))
            (loop for e in (neighbors graph start)
               do (when (not (member e visited))
                    (setf visited
                          (dfs graph e
                               :depth (when depth (- depth 1))
                               :goal goal :visited visited))))))
    (reverse visited)))

(defmethod dls ((graph graph) start depth &key (goal nil) (visited nil))
  (dfs graph start :depth depth :goal goal :visited visited))
