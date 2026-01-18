#lang racket

(require 2htdp/universe)
(require 2htdp/image)
(require "defs.rkt")
(require "game-logic.rkt")
(require "rendering.rkt")

(define (handle_key g key)
  (cond
    [(string=? key "w")   (game (game-snake g) (game-food g) "up")]
    [(string=? key "s")   (game (game-snake g) (game-food g) "down")]
    [(string=? key "a")   (game (game-snake g) (game-food g) "left")]
    [(string=? key "d")   (game (game-snake g) (game-food g) "right")]
    [else                 g] ;; Do nothing on other keys
    )
  )

;; Start the game

(big-bang initial-game
  (to-draw render_game)
  (on-tick next_state 0.3)
  (on-key handle_key)
  )
