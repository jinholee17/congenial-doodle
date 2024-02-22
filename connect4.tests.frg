#lang forge/bsl

open "connect4.frg"
// DO NOT EDIT above this line  

------------------------------------------------------------------------
pred malformedBoard[b: Board]{
    some row, col: Int, player: Player | {
        (row < 0 or row > 6 or col < 0 or col > 7)
        b.board[row][col] = player
    }
}

test suite for wellformed {
    test expect {
        notBoth:{
            all b: Board |{
                wellformed[b]
                malformedBoard[b]
            }
        } is unsat
    } 
}

pred notYellowTurn[b: Board] {
    not yellowTurn[b]
}
pred notRedTurn[b: Board] {
    not redTurn[b]
}

test suite for redTurn {
    test expect{
        balancedRed:{
            all b: Board |{
                balanced[b]
                notYellowTurn[b] implies{
                redTurn[b]
                }
            }
        } is sat
        unbalancedRed:{
            all b: Board |{
                not balanced[b] implies{
                    notRedTurn[b]
                    redTurn[b]
                }
            }
        } is sat
    }
}
test suite for yellowTurn {
    test expect{
        yellowWorks:{
            all b: Board |{
                balanced[b]
                notRedTurn[b] implies{
                yellowTurn[b]
                }
            }
        } is sat
        unbalancedYellow:{
            all b: Board |{
                not balanced[b] implies{
                    notYellowTurn[b]
                    yellowTurn[b]
                }
            }
        } is sat
    }
}

test suite for winner {
    test expect{
        onlyOneWinner:{
            all b: Board | some p1,p2: Player |{
                oneWinner[b,p1,p2] implies{
                winner[b,p1] or winner[b,p2]
                }
            }
        } is sat
    }
}

test suite for balanced {
    test expect{
        goodBalance:{
            all b: Board | some p1: Player |{
                balanced[b] implies{
                    wellformed[b]
                    winner[b,p1] or winner[b,p1]
                }
            }
        } is sat
    }
}

test suite for move {
    test expect{
        goodMove:{
            all b: Board | { some Game.next[b] implies {
                some row, col: Int, p: Player | {
                    move[b, row, col, p, Game.next[b]] implies
                    {
                        validRowPosition[b,row,col,p]
                    }
                }
                }
            }
        }is sat
    }
}
test suite for doNothing {
    test expect{
        winnerDoNothing:{
            all b: Board | some p: Player | {
                winner[b,p] implies{
                    doNothing[b]
                }
            }
        } is sat
    }
}