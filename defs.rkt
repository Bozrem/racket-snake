#lang racket
(provide (all-defined-out))


(define WIDTH 20)
(define HEIGHT 20)

(struct position (x y) #:transparent)
(struct game (snake food dir) #:transparent)

(define initial-snake (cons (position 1 0) (cons (position 0 0) empty)))
(define initial-food  (position 3 3))
(define initial-game  (game initial-snake initial-food "right"))
