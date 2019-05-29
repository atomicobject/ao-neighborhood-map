#lang racket
(require sfont/geometry)
(require threading)



; Public
(provide create-vector)
(provide test-vertex->vector)
(provide vertex?)



; Convenience constructor for a vector that takes a pair of points.
; Pair(String) -> Vector
(define (create-vector pair)
  (vec (string->number (first pair)) (string->number (second pair))))

(module+ test
  (require rackunit)
  (check-equal?
   (create-vector (list "-85.646282" "42.912051"))
   (vec -85.646282 42.912051))
  )

; Convert a test data input line to a vector
; String -> Vector
(define test-vertex->vector
  (lambda~> (string-split _ ": ")
            last
            string-trim
            (string-split _ ",")
            create-vector))

(module+ test
  (check-equal?
   (test-vertex->vector "Point 2: -85.646726,42.913097")
   (vec -85.646726 42.913097))
  )

; Tests if a file line represents a vertex
; String -> Boolean
(define (vertex? line)
  (string-contains? line ","))

(module+ test
  (check-true (vertex?  "      -85.648052564782,42.9273362102149"))
  (check-false (vertex? " Alger Heights:"))
  (check-false (vertex? "\n"))
  )