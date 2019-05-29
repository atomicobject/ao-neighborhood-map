#lang racket
(require sfont/geometry)
(require threading)

(require "modules/neighborhood.rkt")
(require "modules/vertex.rkt")






; << Main >>

; This is the main function that has the whole flow of reading in neighborhoods,
; test data, and outputs the results.
; Takes in a file name for the neighborhood map.
; String -> Null
(define generate-results
  (lambda~> match-neighborhoods-for
            format-results
            write-results))



; << File In / Parsing >>

; Matches the points in a given test data file with neighborhoods
; that contain each point.
; String -> ListOf(Neighborhood/#f)
(define (match-neighborhoods-for test-data-file)
  (for/list ([point (read-test-data test-data-file)])
    (match-neighborhood (file->neighborhoods "gr_neighborhoods.txt") point)))

; Reads the test data points file and converts to a list of vectors.
; String -> ListOf(Vec)
(define read-test-data
  (lambda~>> file->lines
             (map test-vertex->vector _)))

; Reads the nighborhood file and folds it into a list of neighborhood objects.
; String -> ListOf(Neighborhood)
(define (file->neighborhoods filename)
  (foldl generate-neighborhoods '() (file->lines filename)))

; Takes a string and a list of neighborhoods and if it is a location
; adds the location to the current neighborhood. If it is a neighborhood it
; adds the neighborhood to the list of neighborhoods.
; String -> ListOf(Neighborhood)
(define (generate-neighborhoods nextLine listOfNeighborhoods)
  (cond [(neighborhood-name? nextLine) (~>> nextLine
                                            create-neighborhood
                                            list
                                            (append listOfNeighborhoods))]
        [(vertex? nextLine) (~> nextLine
                                string-trim
                                (string-split _ ",")
                                create-vector
                                (add-vertex _ (last listOfNeighborhoods)))
                            listOfNeighborhoods]
        [else listOfNeighborhoods]))



; << Match Point to Neighborhood >>

; Returns the neighborhood in a list of neighborhoods that contains the point, or false if none match.
; ListOf(Neighborhood) Vec -> Neighborhood/#f
(define (match-neighborhood hoods point)
  (findf (lambda (hood)
           (point-is-in-neighborhood hood point))
         hoods))

; Determines if a given point is in a given neighborhood.
; Nieghborhood Vec -> Boolean
(define (point-is-in-neighborhood hood point)
  (odd? (intersection-count hood point)))

; Counts the number of times a line segment from (0,0) to "point" intersects with
; the boundaries of a neighborhood.
(define (intersection-count hood point)
  (~> hood
      (intersection-list _ point)
      (filter has-value? _)
      length))

; Converts any non #f value to #t
; Any -> Boolean
(define (has-value? result)
  (not (not result)))

; Tests every line segment that makes up the boundaries of a neighborhood for an intersection
; with the line segment from (0,0) to "point". Returns a list containing both intersection points and
; #f where it does not intersect.
; Neighborhood Point -> ListOf(Vec/#f)
(define (intersection-list hood point)
  (for/list ([i (neighborhood-vertices hood)]
             [j (rest (neighborhood-vertices hood))])
             (segment-intersection (vec 0 0) point i j)))



; << File Out >>

; Formats a list of neighborhoods into a list of strings.
; ListOf(Neighborhood/#f) -> ListOf(String)
(define (format-results results)
  (for/list ([i (length results)]
             [hood results])
    (if hood
        (format "Point ~a: ~a" (+ 1 i) (neighborhood-name hood))
        (format "Point ~a:" (+ 1 i)))))

; Prints the result strings to a file and to the console.
; ListOf(String) -> Null
(define (write-results results)
  (call-with-output-file "output.txt"
    #:exists 'replace
    (lambda (out-port)
      (for ([line results])
        (displayln line)
        (displayln line out-port)))))



; << Execute >>

; Executes the neighborhood matching.
(generate-results "test_data.txt")
