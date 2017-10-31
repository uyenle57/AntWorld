
//Initialise the world

public void initWorld() {
    
  //The world
  numRows = 16;
  numCols = 16;
  cellWidth = windowWidth / numCols;
  cellHeight = windowWidth / numCols;
  cells = new Cell[numRows][numCols];
  for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numCols; col++) {
          cells[row][col] = new Cell(new Location(row, col), Cell.BACKGROUND);
    }
  }

  random = new Random(); //Pseudorandom number generator (PRNG)
  
  env = Env.UNINFORMED;
  strategy = Strategy.DFS_GRAPH;
  
  // Add False food in the Deception environment
  if (env == Env.DECEPTION) {
    falseFood = new Location(2, numCols - 3);
    cells[falseFood.row][falseFood.col].state = Cell.FALSEFOOD;
  }
  
  // number of searchers
  if (strategy == Strategy.SWARM)
    numAnts = 5;
  else
    numAnts = 1;

  //Nest
  nest = new Location(2, 2);
  cells[nest.row][nest.col].state = Cell.NEST;
  
  //Food
  food = new Location(numRows - 3, numCols - 3);
  cells[food.row][food.col].state = Cell.FOOD;

  //Ants
  ants = new ArrayList<Ant>();
  for (int i = 0; i < numAnts; i++)
    ants.add(new Ant(nest, this));

  //Obstacles
  //cells[numRows / 2][numCols / 2].state = Cell.OBSTACLE;
  //cells[numRows / 2 - 1][numCols / 2].state = Cell.OBSTACLE;
  //cells[numRows / 2 + 1][numCols / 2 - 2].state = Cell.OBSTACLE;
  //cells[numRows / 2 + 2][numCols / 2 - 2].state = Cell.OBSTACLE;
}



// Draw Ants, Cells and Grid

void drawAnts() {
  rectMode(CORNER);
  noStroke();
  
  float col = 0; 
  
  for (int i = 0; i < ants.size(); i++) {

    Ant ant = ants.get(i);

    for (Location l : ant.explored) {
      col++;
      col %= 255;
      fill(col, 255, 255, 40); //rainbow colors
      rect(l.col * cellWidth, l.row * cellHeight, cellWidth, cellHeight);
    }

    if (inWorld(ant)) {
      fill(ANT);
      rect(ant.pos.col * cellWidth, ant.pos.row * cellHeight, cellWidth, cellHeight);
    }
  }
}

void drawCells() {
  noStroke();
  rectMode(CORNER);

  for (int col = 0; col < numCols; col++) {
    for (int row = 0; row < numRows; row++) {

      if (cells[row][col].state != Cell.BACKGROUND) {

        fill(stateToColour.get(cells[row][col].state));
        rect(col * cellWidth, row * cellHeight, cellWidth, cellHeight);
      }
    }
  }
}

void drawGrid() {
  stroke(0, 40);

  for (int col = 1; col <= numCols; col++) {
    line(col * cellWidth, 0, col * cellWidth, height);
  }

  for (int row = 1; row <= numRows; row++) {
    line(0, row * cellHeight, windowWidth, row * cellHeight);
  }
}



// User Interactions

public void keyPressed() {
  
  if (key == ' ')
    pause = !pause;
  else if (key == 't')
    toggle = !toggle;
}

public void mouseClicked() {
  
  int row = (int) (mouseY / cellWidth);
  int col = (int) (mouseX / cellHeight);
  Location loc = new Location(row, col);
  if (!loc.equals(food) && !loc.equals(nest))
    setCellState(row, col, toggle ? Cell.BACKGROUND : Cell.OBSTACLE);

  println(updateEnv(loc));
}

public void mouseDragged() {
  
  int row = (int) (mouseY / cellWidth);
  int col = (int) (mouseX / cellHeight);
  Location loc = new Location(row, col);
  if (!loc.equals(food) && !loc.equals(nest))
    setCellState(row, col, toggle ? Cell.OBSTACLE : Cell.BACKGROUND);
}