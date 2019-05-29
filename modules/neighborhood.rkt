#lang racket
(require sfont/geometry)
(require threading)



; Public
(provide (struct-out neighborhood))
(provide create-neighborhood)
(provide pretty-neighborhood-name)
(provide add-vertex)
(provide neighborhood-name?)



; Neighborhood
;   name: String
;   vertices: listof vector
(struct neighborhood (name vertices) #:mutable)

; Neighborhood convenience constructor
; String -> Neighborhood
(define (create-neighborhood name)
    (neighborhood (pretty-neighborhood-name name) '()))

(module+ test
  (require rackunit)
  (check-equal?
   (neighborhood-name (create-neighborhood " Alger Heights: "))
   "Alger Heights")
  (check-equal?
   (neighborhood-vertices (create-neighborhood " Alger Heights: "))
   '())
  )

; Clean up the neighborhood name
; String -> String
(define (pretty-neighborhood-name name)
  (string-trim (string-trim name) ":"))

(module+ test
  (check-equal?
   (pretty-neighborhood-name " Baxter:\n")
   "Baxter")
  )

; Add vertex to neighborhood
; Neighborhood -> Neighborhood
(define (add-vertex vector hood)
  (~> hood
      (neighborhood-vertices _)
      (append _ (list vector))
      (set-neighborhood-vertices! hood _))
  hood)

(module+ test
  (check-equal?
   (let ([hood (create-neighborhood "Baxter")])
     (neighborhood-vertices (add-vertex (vec 2 5) hood)))
   (list (vec 2 5)))
  )

; Tests if a file line represents a neighborhood name
; String -> Boolean
(define (neighborhood-name? line)
  (string-suffix? line ":"))

(module+ test
  (check-true (neighborhood-name? " Baxter:"))
  (check-false (neighborhood-name? "\n"))
  (check-false (neighborhood-name? "       -85.648052564782,42.9273362102149"))
  )
