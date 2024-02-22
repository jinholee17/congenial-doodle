const d3 = require('d3'); 
d3.selectAll("svg > *").remove(); 
 
const numRows = 6; 
const numCols = 7; 
 
function printValue(row, col, yoffset, value) { 
  const cellSize = 30; 
  const gapSize = 5; 
 
  d3.select(svg) 
    .append("text") 
    .style("fill", "black") 
    .attr("x", (col + 1) * (cellSize + gapSize) - cellSize / 2 + 5) 
    .attr("y", (row + 1) * (cellSize + gapSize) + yoffset + cellSize / 2) 
    .attr("text-anchor", "middle") 
    .attr("dominant-baseline", "middle") 
    .text(value); 
} 
 
 
function printState(stateAtom, yoffset) { 
  const cellSize = 30; 
  const gapSize = 5; 
 
  // Print the board values 
  for (let r = 0; r < numRows; r++) { 
    for (let c = 0; c < numCols; c++) { 
      printValue(r, c, yoffset, stateAtom.board[r][c].toString().substring(0, 1)); 
    } 
  } 
 
  // Draw horizontal grid lines 
  for (let r = 0; r <= numRows; r++) { 
    d3.select(svg) 
      .append('line') 
      .attr('x1', 5) 
      .attr('y1', yoffset + r * (cellSize + gapSize)) 
      .attr('x2', (numCols * cellSize) + 5) 
      .attr('y2', yoffset + r * (cellSize + gapSize)) 
      .attr('stroke', 'black'); 
  } 
 
  // Draw vertical grid lines 
  for (let c = 0; c < numCols; c++) { 
    d3.select(svg) 
      .append('line') 
      .attr('x1', c * (cellSize + gapSize) + 5) 
      .attr('y1', yoffset) 
      .attr('x2', c * (cellSize + gapSize) + 5) 
      .attr('y2', yoffset + numRows * (cellSize + gapSize)) 
      .attr('stroke', 'black'); 
  } 
} 
 
 
var offset = 0; 
const cellSize = 30; 
for (let b = 0; b <= 10; b++) { 
  if (Board.atom("Board" + b) != null) 
    printState(Board.atom("Board" + b), offset); 
  offset = offset + (numRows * 35) + 5; 
} 
