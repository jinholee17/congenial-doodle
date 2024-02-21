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
    (row < 0 or row > 6 or col < 0 or col > 7) implies
        no b.board[row][col]      
    }
}

// initial board 
pred initial[s: Board] {
    all row, col: Int | no s.board[row][col]
}

-- red goes first 
pred redTurn[b : Board] {
    #{row, col: Int | b.board[row][col] = Red} 
    = 
    #{row, col: Int | b.board[row][col] = Yellow} 
}

-- yellow goes second 
pred yellowTurn[b : Board] {
    #{row, col: Int | b.board[row][col] = Red} 
    = 
    add[#{row, col: Int | b.board[row][col] = Yellow}, 1]
}

// helper pred
pred winRow[b: Board, p: Player] {
    some row, col: Int | {
        b.board[row][col] = p
        b.board[row][add[col,1]] = p
        b.board[row][add[col,2]] = p
        b.board[row][add[col,3]] = p
    }
}

pred winCol[b: Board, p: Player] {
    some row,col: Int | {
        b.board[row][col] = p
        b.board[add[row,1]][col] = p
        b.board[add[row,2]][col] = p
        b.board[add[row,3]][col] = p
    }
}


pred winDiagonal[b: Board, p: Player] {
    some row,col,dirY,dirX: Int | {
        dirY = -1 or dirY = 1
        dirX = -1 or dirX = 1
        b.board[row][col] = p
        b.board[add[row,dirY]][add[col,dirX]] = p
        b.board[add[row,multiply[2,dirY]]][add[col,multiply[2,dirX]]] = p
        b.board[add[row,multiply[3,dirY]]][add[col,multiply[3,dirX]]] = p
    }
}

// use helper predicates 
pred winner[b: Board, p: Player] {
    winRow[b, p] or winCol[b, p] or winDiagonal[b, p]
}

// balance turns 
pred balanced[s: Board] {
  redTurn[s] or yellowTurn[s]
}

// make sure the turns are not in the middle and are stacked on one another 
pred validMovetoBottom {
    
}

pred move[pre: Board, row: Int, col: Int, turn: Player, post: Board] {
    -- guard 
    no pre.board[row, col]
    turn = Yellow implies yellowTurn[pre]
    turn = Red implies redTurn[pre]

    // can we call wellformed instead ? 
    row >= 0 
    row <= 6 
    col >= 0
    col <= 7
    -- balance the game 
    
    // mark location on board 
    post.board[row][col] = turn
    // check for winner 
    all row2, col2 :Int | (row != row2 or col != col2) implies {
        post.board[row2][col2] = pre.board[row2][col2]
    } 

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

/* run {
    some b : Board, p: Player | {
        wellformed[b]
        // initial[b]
        winner[b,p]
    }
} */

run {
    some pre, post: Board | {
        some row, col: Int, p: Player | 
            wellformed[pre]
            move[pre, row, col, p, post]
    }
}