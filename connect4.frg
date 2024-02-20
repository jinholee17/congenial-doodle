#lang forge/bsl
abstract sig Player {}
one sig Yellow, Red extends Player {}

sig Board {
  board: pfunc Int -> Int -> Player
}

pred wellformed [b: Board] {
    all row, col: Int | {
    (row < 0 or row > 6 or col < 0 or col > 7) 
        implies no b.board[row][col]      
    }
}

pred initial[s: Board] {
    all row, col: Int | 
        no s.board[row][col]
}


pred yellowTurn {

}

pred redTurn {

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
  yellowTurn[s] or redTurn[s]
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
    some b : Board, p: Player | {
        wellformed[b]
        // initial[b]
        winner[b,p]
    }
}