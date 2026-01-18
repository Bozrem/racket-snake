#lang racket
(provide next_state) ;; Everything

(require 2htdp/universe)
(require 2htdp/image)
(require "defs.rkt")

(define (move_head p dir)
  (cond
    [(string=? dir "up")    (position (position-x p) (- (position-y p) 1))]
    [(string=? dir "down")  (position (position-x p) (+ 1 (position-y p)))]
    [(string=? dir "right") (position (+ 1 (position-x p)) (position-y p))]
    [(string=? dir "left")  (position (- (position-x p) 1) (position-y p))]
    [else p] ;; Fail soft
    )
  )


(define (wall_collision? p)
  (cond
    [(>= (position-x p) WIDTH)  #t]  ;; X > WIDTH
    [(<  (position-x p) 0)      #t]  ;; X <= -1
    [(>= (position-y p) HEIGHT) #t]  ;; Y > HEIGHT
    [(<  (position-y p) 0)      #t]  ;; Y <= -1
    [else         #f]
    )
  )


(define (self_collision? head body)
  (cond
    [(empty? body)              #f]
    [(equal? (first body) head) #t]
    [else   (self_collision? head (rest body))]
    )
  )


(define (food_collision? head food)
  (cond
    [(equal? head food) #t]
    [else               #f]
    )
  ) ;; I know this is technically a pretty useless function, but oh well it makes next state cleaner


(define (remove_last body)
  (cond
    [(empty? (rest body)) empty] ;; This means if the one after is empty, 
    [else  (cons (first body) (remove_last (rest body)))]
    )
  )


(define (next_state g)
  (define curr-snake (game-snake g))
  (define food (game-food g))
  (define dir (game-dir g))

  (define next-head (move_head (first (game-snake g)) dir))

  (define next-snake (cons next-head curr-snake)) ;; Just add the head here

  (cond
    [(or (wall_collision? next-head) ;; If we hit the wall
         (self_collision? next-head curr-snake)) ;; Or hit ourself
      initial-game] ;; Restart (lose, but I didn't want to figure out how quitting works)

    [(not (food_collision? next-head food)) ;; If we didn't hit food
      (game (remove_last next-snake) food dir)] ;; Remove the tail

    [else ;; Otherwise (we did hit the food)
      (game next-snake (position (random WIDTH) (random HEIGHT)) dir)] ;; Move the food
    )
  )

