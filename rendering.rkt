#lang racket
(provide render_game)

(require 2htdp/image)
(require "defs.rkt")

;; Definitions - Could go in defs.rkt, but only used here
(define TILE_SIZE 50)
(define BORDER_SIZE 10)

(define SCENE-W (+ (* WIDTH TILE_SIZE)  (* 2 BORDER_SIZE)))
(define SCENE-H (+ (* HEIGHT TILE_SIZE) (* 2 BORDER_SIZE)))

(define (grid_to_pixel v)
  (+ (* v TILE_SIZE)
     (/ TILE_SIZE 2)
     BORDER_SIZE))

;; Checkerboard Generate

(define BG_COLOR_1 "white")
(define BG_COLOR_2 "lightgray")

(define CHECKERBOARD
  (for*/fold ([scene (empty-scene SCENE-W SCENE-H)]) ;; Start with empty
             ([x (in-range WIDTH)]                   ;; Loop x
              [y (in-range HEIGHT)])                 ;; Loop y
    (define color (if (even? (+ x y)) BG_COLOR_1 BG_COLOR_2))
    (define tile-img (square TILE_SIZE "solid" color))

    (place-image tile-img
                 (grid_to_pixel x)
                 (grid_to_pixel y)
                 scene)))

(define BACKGROUND CHECKERBOARD)


;; Main Images

(define HEAD_IMAGE
  (overlay (square TILE_SIZE "outline" "black")
           (square TILE_SIZE "solid" "green"))
  )

(define BODY_IMAGE
  (overlay (square TILE_SIZE "outline" "black")
           (square TILE_SIZE "solid" "red"))
  )

(define FOOD_IMAGE
  (overlay (circle (/ TILE_SIZE 3) "solid" "gold")
           (circle (/ TILE_SIZE 3) "outline" "black"))
  )


;; Rendering

(define (draw_tile image p item)
  (place-image item
               (grid_to_pixel (position-x p))
               (grid_to_pixel (position-y p))
               image)
  )

(define (draw_body image body item)
  (cond
    [(empty? body) image]
    [else (draw_tile (draw_body image (rest body) item) (first body) item)]
    )
  )

(define (render_game g)
  (define snake (game-snake g))
  (define food (game-food g))

  (define food-added (draw_tile BACKGROUND food FOOD_IMAGE))
  (define body-added (draw_body food-added (rest snake) BODY_IMAGE))
  (define head-added (draw_tile body-added (first snake) HEAD_IMAGE))

  head-added
  )
