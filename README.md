
Yet another attempt to make simple graph library in Common Lisp

Installation
-----------

        cd ~/quicklisp/local-projects
        git clone https://github.com/aluuu/grafico.git

        # in slime/lisp-repl
        CL-USER> (ql:quickload :grafico)

        # while working in repl
        CL-USER> (in-package :grafico)

Examples
-----------

Let's make simple graph:

        GRAFICO> (defvar my-graph (make-instance 'graph))
        MY-GRAPH

Add some nodes:

        GRAFICO> (add-node my-graph 'a)
        A
        GRAFICO> (add-node my-graph 'b)
        B

Connect them:

        GRAFICO> (add-edge my-graph 'a 'b)
        (A . B)

Inpecting nodes and edges:

        GRAFICO> (nodes my-graph)
        (B A)
        GRAFICO> (edges my-graph)
        ((A . B))

So, we want to create directed graph from edges, that we know:

        GRAFICO> (setf my-graph (edges->graph '((a . b) (b . c) (c . d) (a . d)) :graph-class 'digraph))
        #<DIGRAPH {100599B1F3}>
        GRAFICO> (edges my-graph)
        ((A . D) (C . D) (B . C) (A . B))
        GRAFICO> (nodes my-graph)
        (D C B A)

Finally, we can render it to image via Graphviz (*works only in sbcl*):

        GRAFICO> (render-graph my-graph #P"/tmp/my-graph.png" :png)


TODO
===========

* improve docs;
* add more algorithm;
* implement `render-graph` for some other CL implementations.