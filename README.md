# connect4 
Project Objective: 
- We tried to model the Connect4 game! Connect 4 is a 2-player (Red or Yellow) turn-based game where each player takes a turn to drop their respective colored tokens in a vertically suspended 6x7 board. The goal for each player is to be the first to form a line of four tokens of your color horizontally, vertically, or diagonally on the grid. The game has many winning combinations dependant on the strategy of both players.

Model Design and Visualization: Give an overview of your model design choices, what checks or run statements you wrote, and what we should expect to see from an instance produced by the Sterling visualizer. How should we look at and interpret an instance created by your spec? Did you create a custom visualization, or did you use the default?
- We wanted to design a classic version of Connect4. This includes modeling the board, each player Red and Yellow, and valid moves that are stacked on top of each other or in the bottom row, and different board states until there is a win condition for any player. 

    - We have one run statement that just checks if the board is wellformed. To run the model with players we created a trace that uses the Game sig that tracks the board states between player moves. First there is an initial board with no players on the board yet. Then, after the initial board, the next boards in the trace are the ones that are going to track the player moves on the board, and if there is a winning condidition, then the states are going to stay the same for however many Boards you specify. 

- When running our model, you will see that there is visualizer for the game. We recommend using the visualizer, however the table is another valid way to interpret our model (Note: to run the model that checks for winnning states, we had to limit the board to have a grid 4x4 so forge can run faster)

    - Looking at the table, you will see that for each board state, the previous player positions are kept in the new boards, with the additions of the new moves made by the player. You will also notice that the first move (Board1) is always on the bottom row (following real-life physics) and moves after that are either stacked (a row position above the previous move postion), or also on the bottom row. Additionally, when there is a winning state, the boards after that are going to stay the same and no new move positions will be introduced and no positions on the board will change. 

    - Our custom visualization visualizes a simple 6x7 grid (however due to limitations, the player positions are going to be in a 4x4 grid in the lower left of the visualization, but can be changed to fill the entire grid with the global constant functions) that symbolizes players Red and Yellow by R and Y in their chosen grid spaces. For x amount of board states specified by our trace, the visualizer will represent each board state with the grids. The visualizer is the best way to interpret our model as it is an accurate visual represenation of the game from real life where the tokens are stacked, and the board grid is visualized. 

Signatures and Predicates: At a high level, what do each of your sigs and preds represent in the context of the model? Justify the purpose for their existence and how they fit together.
- We have 3 sigs in our model. 
    - Board - this sig has a partial function that maps two integers (the board coordinates), to a player (the player position)
    - Player - Red, Yellow, Red and Yellow are 2 sigs that extends the main Player sig that implements a 2 player feature  
    - Game - this one sig models boards into a sequence that represents a running game with players taking turns. This sig is what turns a static board into a dynamic game. 

- Predicates
    - wellformed - this pred ensures our board is wellformed and is not in invalid positions less than the defined min and more than the defined max 
    - initial - this pred ensures that our initial first board does not have any player positions on it and it is empty when starting our game 
    - redTurn and yellowTurn and balanced - these 3 preds use counting to ensure that each player has a turn once the other player already had their turn and that no player can go twice or more in a row. This implements taking turns in our game. 
    - winRow, winCol, winDiagonal, winner - these 4 preds ensure our game is checking for a winnning state. It checks that a player has 4 same colored tokens in a row horizontally, vertically, or diagonally. This checks for a winner in our game. 
    - validRowPosition - this pred ensures that the positions players choose are not floating in the middle of the board and are valid positions. This implements real life physics into our game :O.
    - move - this pred brings together our turn predicates to ensure that players go in order, choose valid positions, and boards are marked correctly and transfered between the previous board state to the next. 
    - doNothing - this pred ensures that the next board will be the same as the previous board and nothing changes between them. 
    - game_trace - this pred creates an initial empty board, then creates our board, player and row and col instances to show how our players move in the game. This implements connect4 when ran. 


Testing: What tests did you write to test your model itself? What tests did you write to verify properties about your domain area? Feel free to give a high-level overview of this.
- 

Documentation: Make sure your model and test files are well-documented. This will help in understanding the structure and logic of your project.

