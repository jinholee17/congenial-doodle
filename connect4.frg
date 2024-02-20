#lang forge/bsl
abstract sig Player {}
one sig Yellow, Red extends Player {}

/* Concepts we want to include 
- board,
- players red and yellow 
- valid moves 
- finite amount of board states 
- win conidtion, tie condition 

constraint: moves can only be stacked or to the side of all-ready occupied 
board postitions - no floating players in middle of board 
constraint: can't be put on top of each other 
constraint: moves alternate 
constraint: game ends if someone won? 
 */


sig Board {
  board: pfunc Int -> Int -> Player
}

-- a wellformed board and there has to be 6 rows and 7 columns
pred wellformed [b: Board] {
    all row, col: Int | {
    (row < 0 or row > 6 or col < 0 or col > 7) 
        implies no b.board[row][col]      
    }
}

pred initial[s: Board] {
    all row, col: Int | no s.board[row][col]
}

-- red goes first 
pred redTurn {
    #{row, col: Int | b.board[row][col] = Red} 
    = 
    #{row, col: Int | b.board[row][col] = Yellow} 
}

-- yellow goes second 
pred yellowTurn {
    #{row, col: Int | b.board[row][col] = Red} 
    = 
    add[#{row, col: Int | b.board[row][col] = Yellow}, 1]
}

// helper pred
pred winRow {
    some 
}

pred winCol {

}


pred winDiagonal {

}

// use helper predicates 
pred anyWin[b : Board, p: Player] {

}

// balance turns 
pred balanced[s: Board] {
  redTurn[s] or yellowTurn[s]
}

// make sure the turns are not in the middle and are stacked on one another 
pred validMovetoBottom {

}

// something similar 
/* one sig Game {
    first: one Board, 
    next: pfunc Board -> Board
}
pred game_trace {
    initial[Game.first]
    all b: Board | { some Game.next[b] implies {
        some row, col: Int, p: Player | 
            move[b, row, col, p, Game.next[b]]
        -- TODO: ensure X moves first
    }}
}
run { game_trace } for 10 Board for {next is linear}
// ^ the annotation is faster than the constraint */

/// Feb 5 ///

/* -- "transition relation"
pred move[pre: Board, 
          row, col: Int, 
          turn: Player, 
          post: Board] {
    -- guard: conditions necessary to make a move  
    -- cant move somewhere with an existing mark
    -- valid move location
    -- it needs to be the player's turn 
    no pre.board[row][col]
    turn = X implies xturn[pre]
    turn = O implies oturn[pre]

    -- balanced game
    -- game hasn't been won yet
    -- if it's a tie can't move 
    -- board needs to be well-formed 

    -- action: effects of making a move

    -- mark the location with the player 
    post.board[row][col] = turn 
    -- updating the board; check for winner or tie 
    -- other squares stay the same  ("frame condition")
    all row2: Int, col2: Int | (row!=row2 or col!=col2) implies {
        post.board[row2][col2] = pre.board[row2][col2]
    }


} */

run {
    some b : Board | {
        wellformed[b]
        initial[b]
    }
}