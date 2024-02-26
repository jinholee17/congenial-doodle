#lang forge/bsl

open "connect4.frg"
// DO NOT EDIT above this line  

------------------------------------------------------------------------
-- helper predicate to test a malformed board
pred malformedBoard[b: Board]{
    some row, col: Int, player: Player | {
        (row < 0 or row > 6 or col < 0 or col > 7)
        b.board[row][col] = player
    }
}
-- tests for wellformed
test suite for wellformed {
    test expect {
        notBoth:{
            all b: Board |{
                wellformed[b]
                malformedBoard[b]
            }
        } is unsat
        somewellformed:{
            all b: Board |{
                wellformed[b]
            }
        } is sat
    } 
}

-- helper predicate for implying not a player's turn
pred notYellowTurn[b: Board] {
    not yellowTurn[b]
}
-- helper predicate for implying not a player's turn
pred notRedTurn[b: Board] {
    not redTurn[b]
}
-- tests for red's turns
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
-- tests for yellow's turns
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
-- tests for winner
test suite for winner {
    test expect{
        onlyOneWinner:{
            all b: Board | some p1,p2: Player |{
                oneWinner[b,p1,p2] implies{
                winner[b,p1] or winner[b,p2]
                }
            }
        } is sat
        onlyOneWinner2:{
            all b: Board | some p1,p2: Player |{
                notWinner[b,p1] implies{
                winner[b,p2]
                }
            }
        } is sat
    }
}
-- tests for balanced
test suite for balanced {
    test expect{
        goodBalance:{
            all b: Board | some p1,p2: Player |{
                balanced[b] implies{
                    wellformed[b]
                    winner[b,p1] or winner[b,p2]
                    notWinner[b,p1] or notWinner[b,p2]
                }
            }
        } is sat
        badBalance:{
            all b: Board | some p1,p2: Player |{
                not balanced[b] implies{
                    winner[b,p1] and winner[b,p2]
                }
            }
        } is sat
    }
}
--tests for move
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
        badMove:{
            all b: Board | { some Game.next[b] implies {
                some row, col: Int, p: Player | {
                    not validRowPosition[b,row,col,p] implies
                    {
                        not move[b, row, col, p, Game.next[b]]
                    }
                }
                }
            }
        }is sat
    }
}
-- tests for doNothing
test suite for doNothing {
    test expect{
        winnerDoNothing:{
            all b: Board | some p: Player | {
                winner[b,p] implies{
                    doNothing[b]
                }
            }
        } is sat
        winnerDoSomething:{
            all b: Board | some p: Player | {
                not winner[b,p] implies{
                    not doNothing[b]
                }
            }
        } is sat
    }
}