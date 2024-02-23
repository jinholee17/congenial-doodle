#lang forge/bsl
abstract sig Player {}
one sig Yellow, Red extends Player {}

/* Concepts we want to include 
- board,
- players red and yellow 
- valid moves 
- finite amount of board states 
- win condition

constraint: moves can only be stacked or to the side of all-ready occupied 
board postitions - no floating players in middle of board 
constraint: can't be at same position 
constraint: moves alternate 
constraint: game state stays same when someone wins 
 */

-- model each board postions 
sig Board {
  board: pfunc Int -> Int -> Player
}

-- a game state that tracks each board for each move 
one sig Game {
    first: one Board, 
    next: pfunc Board -> Board
}

-- global constants for the min and max numbers of rows and columns on the board 
-- for connect4 we want 6x7 but made 4x4 for forge efficiency  
fun MIN: one Int { 0 }
fun ROW_MAX: one Int { 3 } // originally 5 
fun COL_MAX: one Int { 3 } // originally 6


-- a wellformed board has to have valid positions 
pred wellformed [b: Board] {
    all row, col: Int | {
    (row < MIN or row > ROW_MAX or col < MIN or col > COL_MAX ) implies
        no b.board[row][col]      
    }
}

-- make sure our board is wellformed 
/* run {
    some pre, post: Board | {
        some r, c: Int, p: Player | 
            wellformed[pre]
    }
} for 1 Board */

-- an initial board has no players 
pred initial[s: Board] {
    all row, col: Int | no s.board[row][col]
}

-- red goes first and we count the turns 
pred redTurn[b : Board] {
    #{row, col: Int | b.board[row][col] = Red} 
    = 
    #{row, col: Int | b.board[row][col] = Yellow} 
}

-- yellow goes second and we count the turns 
pred yellowTurn[b : Board] {
    #{row, col: Int | b.board[row][col] = Red} 
    = 
    add[#{row, col: Int | b.board[row][col] = Yellow}, 1]
}

-- balance the turns 
pred balanced[s: Board] {
  redTurn[s] or yellowTurn[s]
}


-- helper predicate to track a winner on rows 
pred winRow[b: Board, p: Player] {
    some row, col: Int | {
        b.board[row][col] = p
        b.board[row][add[col,1]] = p
        b.board[row][add[col,2]] = p
        b.board[row][add[col,3]] = p
    }
}

-- helper predicate to track a winner in columns 
pred winCol[b: Board, p: Player] {
    some row,col: Int | {
        b.board[row][col] = p
        b.board[add[row,1]][col] = p
        b.board[add[row,2]][col] = p
        b.board[add[row,3]][col] = p
    }
}

-- helper predicate to track a winner that is diagonal
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

-- use the win helper predicates to constrain the requirements of a winning board 
pred winner[b: Board, p: Player] {
    winRow[b, p] or winCol[b, p] or winDiagonal[b, p]
}

-- not a winner 
pred notWinner[b: Board, p: Player] {
    not (winRow[b, p] and winCol[b, p] and winDiagonal[b, p])
}

-- one winner implies no other winners
pred oneWinner[b: Board, p1,p2: Player] {
    (winner[b,p1]) implies{
        notWinner[b,p2]        
    }
}

-- predicate to ensure that player positions are not floating and are stacked on one another or on the bottom row
pred validRowPosition[b: Board, row: Int, col: Int, p: Player] {
    some otherp : Player | {
        b.board[row][col] = p implies {// for a valid player position 
            (b.board[subtract[row, 1]][col] = otherp) or (subtract[row, 1] = -1)
        } // there must be another player (token) beneath the player position or it can be at the bottom row
    }
}

-- a move predicate to mark the postions of the players 
pred move[pre: Board, row: Int, col: Int, turn: Player, post: Board] {
    no pre.board[row, col]
    turn = Yellow implies yellowTurn[pre]
    turn = Red implies redTurn[pre]

    // ensure move postions are on the board 
    row >= MIN // 0
    row <= ROW_MAX // 5
    col >= MIN // 0
    col <= COL_MAX // 6
    
    // mark location on board 
    post.board[row][col] = turn
    validRowPosition[post, row, col, turn]
    // the rest is mapped onto the post board 
    all row2, col2 :Int | (row != row2 or col != col2) implies {
        post.board[row2][col2] = pre.board[row2][col2]
    } 
}

-- the number of players in the next board (game) is the same as the current board 
pred doNothing[b: Board] {
    // the next board in the game is the current board, therefore staying the same 
    Game.next[b] = b
}

-- our trace modeling an actual game 
pred game_trace {
    initial[Game.first]
    all b: Board | { some Game.next[b] implies {
        some row, col: Int, p: Player | {
            move[b, row, col, p, Game.next[b]]
            // once we have a winning state, then we do nothing 
            // BUT TAKES FOREVER TO RUN, so make sure to comment out if running on a 6x7 grid to run faster 
/*             winner[b, p] implies {
                doNothing[b] 
            }  */
        }
    }}
}

-- run the visualizer 
option run_sterling "connect4viz.js"

-- run the game trace 
run { game_trace } for 20 Board for {next is linear}


