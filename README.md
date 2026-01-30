# Racket Snake
This is a nice simple project I made to familiarize myself more with the Racket language

## Design

### Game State
The game state is pretty simple. It consists of:
- A food position
- A current direction
- A list of snake positions

### Game logic
There are three separate conditions we can hit in a state transition:
1. Death Collision

This runs a check that the newly generated head is not out of bounds (wall collision), and that it matches no other position in the body list.
If it gets triggered, it simply "updates" the game state to be the initial one, thus ending restarting the game.

2. Food collision

Condition just checks if the new head position matches the food position.
If it does, then the game state returned is the snake with the new head and a new random food location

3. Neither

If we didn't die or grow, just remove the last item in the list (which is technically index 0 for Racket), thus removing the tail

### Rendering
Rendering is also fairly simple.

I use the 2htdp/universe library in this project. It handles all the windowing aspects.

All I need to render is to be able to turn the game state into an image, and it handles everything else.

Here are the components:
1. Checkerboard
Statically defined background image, but this part was written by AI

2. Grid system
I defined grid_to_pixel, which can take positions from the game state and turn them into pixel coordinates based on the defined size

3. Tile Drawing
Just a small abstraction to use grid_to_pixel to draw in a whole board tile with one of the various defined images

The final renderer just takes the background, uses tile drawing to add the food, then the snake body (passed into a recursive body drawing function as `rest snake`), then the snake head (as `first snake`)

### Main
All main needs to do is handle keypresses and set up the 2htdp/universe

The keypresses just produce a new game state with the direction changed to whatever key got pressed.

The universe setup takes in an initial game state, the rendering function, the updating function (game logic) and how often to do so, and a keypress handler.
