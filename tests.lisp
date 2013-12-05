
(in-package #:grafico)

(defun sort-symbols (symbols)
  (sort symbols #'(lambda (a b) (string< (symbol-name a)
                                    (symbol-name b)))))

(test simple-graph
  "Check common graph operations"
  (let ((g (edges->graph '((A . B) (C . D) (A . C)))))

    ;; check nodes and edges
    (is (equal '() (set-difference (nodes g) '(A B C D))))
    (is (equal '() (set-difference (neighbors g 'A) '(B C))))
    (is (= (length (edges g)) 3))
    (is-false (connected-p g 'A 'D))
    (is-true (connected-p g 'C 'A))

    ;; add node
    (add-node g 'E)
    (is (= (length (nodes g)) 5))
    (is (= (length (edges g)) 3))

    ;; add some edges
    (add-edge g 'C 'E)
    (add-edge g 'A 'E)
    (is (= (length (nodes g)) 5))
    (is (= (length (edges g)) 5))))

(test simple-digraph
  "Check common digraph operations"
  (let ((g (edges->graph '((A . B) (C . D) (A . C)) :graph-class 'digraph)))

    ;; check nodes and edges
    (is (equal '() (set-difference (nodes g) '(A B C D))))
    (is (equal '() (set-difference (neighbors g 'A) '(B C))))
    (is (= (length (edges g)) 3))
    (is-false (connected-p g 'A 'D))
    (is-false (connected-p g 'C 'A))
    (is-true (connected-p g 'A 'C))

    ;; add node
    (add-node g 'E)
    (is (= (length (nodes g)) 5))
    (is (= (length (edges g)) 3))

    ;; add some edges
    (add-edge g 'C 'E)
    (add-edge g 'A 'E)
    (is-false (connected-p g 'E 'A))
    (is-true (connected-p g 'A 'E))
    (is (= (length (nodes g)) 5))
    (is (= (length (edges g)) 5))))

(defun run-tests ()
  (run! 'simple-graph)
  (run! 'simple-digraph))
