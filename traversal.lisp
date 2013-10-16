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

(defmethod dfs ((graph graph) start &key (goal nil) (queue nil) (visited nil))
  (let ((queue (when (not queue) (make-instance 'deque :items `(,start))))
        (visited visited))
    (loop while (> (length queue) 0)
       do (let ((v (pop-left queue)))
            (when (not (member v visited))
              (setf visited (cons v visited)))
            (if (not (equal goal v))
                (loop for e in (neighbors graph v)
                   do (when (not (member e visited))
                        (append-left queue e))))
            (dfs graph v :goal goal :queue queue :visited visited)))
    (reverse visited)))
